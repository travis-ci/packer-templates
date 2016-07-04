require 'English'

require 'json'
require 'net/https'
require 'optparse'
require 'uri'
require 'logger'

require 'faraday'
require 'git'

module Downstreams
  class Trigger
    def self.run!(argv: ARGV)
      new.run(argv: argv)
    end

    def run(argv: ARGV)
      parse_args(argv)

      ret = 0
      triggered = 0
      errored = 0
      http = build_http

      build_requests.each do |template, request|
        if options.noop
          log.info "Not triggering template=#{template} repo=#{options.repo_slug}"
          next
        end

        response = http.post do |req|
          req.url request.url
          req.headers.merge!(request.headers)
          req.body = request.body
        end

        if response.status < 299
          log.info "Triggered template=#{template} repo=#{options.repo_slug}"
          triggered += 1
          next
        end

        if response.content_type =~ /\bjson\b/
          puts JSON.parse(response.body).fetch('error', '???')
        else
          puts response.body
        end
        errored += 1
        ret = 1
      end

      log.info "All done! triggered=#{triggered} errored=#{errored}"
      ret
    end

    def build_requests
      detector.detect(changed_files).map do |template|
        request = TriggerRequest.new(
          File.join('/repo', URI.escape(options.repo_slug, '/'), 'requests'),
          JSON.dump(body(template)),
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Travis-API-Version' => '3',
          'Authorization' => "token #{options.travis_api_token}"
        )
        [template, request]
      end
    end

    def build_http
      Faraday.new(url: options.travis_api)
    end

    private

    def parse_args(argv)
      OptionParser.new do |opts|
        opts.on('-pPATH', '--cookbook-path=PATH',
                'Cookbook path (":"-delimited). ' \
                "default=#{options.cookbook_path}") do |v|
          options.cookbook_path = parse_path(v)
        end

        opts.on('-tPATH', '--packer-templates-path=PATH',
                'Packer templates path (":"-delimited). ' \
                "default=#{options.packer_templates_path}") do |v|
          options.packer_templates_path = parse_path(v)
        end

        opts.on('-gDIR', '--git-working-copy=DIR',
                'Root of git working copy to check. ' \
                "default=#{options.git_working_copy}") do |v|
          options.git_working_copy = File.expand_path(v.strip)
        end

        opts.on('-XFILENAMES', '--trigger-paths=FILENAMES',
                'File names to force triggering, overriding git ' \
                "(\":\"-delimited). default=#{options.trigger_paths}") do |v|
          options.trigger_paths = parse_path(v.strip)
        end

        opts.on('-rREPO', '--repo-slug=REPO',
                'Repo slug to which triggered builds should be sent. ' \
                "default=#{options.repo_slug}") do |v|
          options.repo_slug = v.strip
        end

        opts.on('-uURL', '--travis-api-url=URL',
                'URL of the Travis API to which triggered builds should ' \
                "be sent. default=#{options.travis_api}") do |v|
          options.travis_api = URI(v)
        end

        opts.on('-TTOKEN', '--travis-api-token=TOKEN',
                'API token for use with Travis API. ' \
                "default=#{options.travis_api_token}") do |v|
          options.travis_api_token = v.strip
        end

        opts.on('-CCOMMIT', '--commit=COMMIT',
                'Commit tree-ish to set REPO in triggered build. ' \
                "default=#{options.commit}") do |v|
          options.commit = v.strip
        end

        opts.on('-BBRANCH', '--branch=BRANCH',
                'Branch name to clone of REPO in triggered build. ' \
                "default=#{options.branch}") do |v|
          options.branch = v.strip
        end

        opts.on('-bBUILDERS', '--builders=BUILDERS',
                'Packer builder names for which Travis jobs should ' \
                'be triggered (","-delimited). ' \
                "default=#{options.builders}") do |v|
          options.builders = v.split(',').map(&:strip)
        end

        opts.on('-n', '--noop', 'Do not do') do
          options.noop = true
        end

        opts.on('-q', '--quiet', 'Simmer down the logging') do
          options.quiet = true
        end
      end.parse!(argv)
    end

    def options
      @options ||= TriggerOptions.new(
        parse_path(
          ENV.fetch(
            'COOKBOOK_PATH',
            File.expand_path('../../../cookbooks', __FILE__)
          )
        ),
        parse_path(
          ENV.fetch(
            'PACKER_TEMPLATES',
            File.expand_path('../../../', __FILE__)
          )
        ),
        File.expand_path(
          ENV.fetch(
            'GIT_WORKING_DIR',
            File.expand_path('../../../', __FILE__)
          )
        ),
        parse_path(ENV.fetch('TRIGGER_PATHS', '')),
        ENV.fetch('REPO_SLUG', 'travis-ci/packer-build'),
        URI(ENV.fetch('TRAVIS_API_URL', 'https://api.travis-ci.org')),
        ENV.fetch('TRAVIS_API_TOKEN', ''),
        ENV.fetch('TRAVIS_COMMIT', ''),
        ENV.fetch('TRAVIS_BRANCH', ''),
        ENV.fetch('BUILDERS', 'amazon-ebs,googlecompute,docker').split(',').map(&:strip),
        ENV['NOOP'] == '1',
        ENV['QUIET'] == '1'
      )
    end

    def parse_path(string)
      string.split(':').map do |p|
        File.expand_path(p.strip)
      end
    end

    def detector
      @detector ||= Downstreams::Detector.new(
        options.cookbook_path,
        options.packer_templates_path
      )
    end

    def body(template)
      {
        message: ":lemon: :bomb: origin-commit=#{options.commit}",
        branch: template,
        config: {
          language: 'generic',
          dist: 'trusty',
          group: 'edge',
          sudo: true,
          env: {
            matrix: options.builders.map { |b| "BUILDER=#{b}" }
          },
          install: [
            "git clone --branch=#{options.branch} " \
              'https://github.com/travis-ci/packer-templates.git',
            "pushd packer-templates && git checkout -qf #{options.commit} ; popd",
            './packer-templates/bin/packer-build-install'
          ],
          script: "./packer-templates/bin/packer-build-script #{template}"
        }
      }
    end

    def changed_files
      return options.trigger_paths unless options.trigger_paths.empty?

      # TODO: replace this with better diff check?  Account for PR?
      last_commit_name_status.select do |_, status|
        %w(M A).include?(status)
      end.map do |filename, _|
        File.expand_path(filename, options.git_working_copy)
      end
    end

    def last_commit_name_status
      git.log(1).first.diff_parent.name_status
    end

    def git
      Git.open(options.git_working_copy)
    end

    def log
      @log ||= Logger.new($stdout).tap do |l|
        l.level = Logger::FATAL if options.quiet
        l.progname = File.basename($PROGRAM_NAME)
        l.formatter = proc do |_, _, progname, msg|
          "#{progname}: #{msg}\n"
        end
      end
    end
  end

  TriggerOptions = Struct.new(
    :cookbook_path,
    :packer_templates_path,
    :git_working_copy,
    :trigger_paths,
    :repo_slug,
    :travis_api,
    :travis_api_token,
    :commit,
    :branch,
    :builders,
    :noop,
    :quiet
  )

  TriggerRequest = Struct.new(
    :url,
    :body,
    :headers
  )
end
