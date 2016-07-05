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
          log.info "Not triggering template=#{template} " \
                   "repo=#{options.repo_slug}"
          next
        end

        response = http.post do |req|
          req.url request.url
          req.headers.merge!(request.headers)
          req.body = request.body
        end

        if response.status < 299
          log.info "Triggered template=#{template} " \
                   "repo=#{options.repo_slug}"
          triggered += 1
          next
        end

        if response.headers['Content-Type'] =~ /\bjson\b/
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
      requests = []
      triggerable_templates.each do |template|
        request = TriggerRequest.new.tap do |req|
          req.url = File.join(
            '/repo', URI.escape(options.repo_slug, '/'), 'requests'
          )
          req.body = JSON.dump(body(template))
          req.headers = {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Travis-API-Version' => '3',
            'Authorization' => "token #{options.travis_api_token}"
          }
        end
        requests << [template, request]
      end
      requests
    end

    def build_http
      Faraday.new(url: options.travis_api_url)
    end

    private

    def parse_args(argv)
      OptionParser.new do |opts|
        opts.on('-gDIR', '--git-working-copy=DIR',
                'Root of git working copy to check. ' \
                "default=#{options.git_working_copy}") do |v|
          options.git_working_copy = File.expand_path(v.strip)
        end

        opts.on('--packer-templates-path=PATH',
                'Packer templates path (":"-delimited). ' \
                "default=#{options.packer_templates_path}") do |v|
          options.packer_templates_path = parse_path(v)
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
                "be sent. default=#{options.travis_api_url}") do |v|
          options.travis_api_url = URI(v)
        end

        opts.on('-TTOKEN', '--travis-api-token=TOKEN',
                'API token for use with Travis API. ' \
                "default=#{options.travis_api_token}") do |v|
          options.travis_api_token = v.strip
        end

        opts.on('-CCOMMIT_RANGE', '--commit-range=COMMIT_RANGE',
                'Commit range to check for changed paths. ' \
                "default=#{options.commit_range}") do |v|
          options.commit_range = v.strip.split('...').map(&:strip)
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

        opts.on('--chef-cookbook-path=PATH',
                'Cookbook path (":"-delimited). ' \
                "default=#{options.chef_cookbook_path}") do |v|
          options.chef_cookbook_path = parse_path(v)
        end
      end.parse!(argv)
    end

    def options
      @options ||= TriggerOptions.new.tap do |opts|
        opts.git_working_copy = File.expand_path(
          ENV.fetch('GIT_WORKING_COPY', Dir.getwd)
        )
        opts.trigger_paths = parse_path(ENV.fetch('TRIGGER_PATHS', ''))
        opts.repo_slug = ENV.fetch('REPO_SLUG', 'travis-ci/packer-build')
        opts.travis_api_url = URI(
          ENV.fetch('TRAVIS_API_URL', 'https://api.travis-ci.org')
        )
        opts.travis_api_token = ENV.fetch('TRAVIS_API_TOKEN', '')

        opts.commit_range = ENV.fetch(
          'COMMIT_RANGE',
          ENV.fetch(
            'TRAVIS_COMMIT_RANGE',
            '@...@' # <--- the empty range
          )
        ).split('...').map(&:strip)

        opts.branch = ENV.fetch('BRANCH', ENV.fetch('TRAVIS_BRANCH', ''))
        opts.builders = ENV.fetch(
          'BUILDERS', 'amazon-ebs,googlecompute,docker'
        ).split(',').map(&:strip)
        opts.noop = ENV['NOOP'] == '1'
        opts.quiet = ENV['QUIET'] == '1'
        opts.chef_cookbook_path = parse_path(
          ENV.fetch(
            'CHEF_COOKBOOK_PATH',
            File.expand_path('../../../cookbooks', __FILE__)
          )
        )
        opts.packer_templates_path = parse_path(
          ENV.fetch(
            'PACKER_TEMPLATES_PATH',
            File.expand_path('../../../', __FILE__)
          )
        )
      end
    end

    def parse_path(string)
      string.split(':').map do |p|
        File.expand_path(p.strip)
      end
    end

    def detectors
      @detectors ||= [
        Downstreams::ChefDetector.new(
          options.chef_cookbook_path,
          options.packer_templates_path
        ),
        Downstreams::FileDetector.new(
          options.packer_templates_path,
          options.git_working_copy
        )
      ]
    end

    def body(template)
      {
        message: ':lemon: :bomb: ' \
          "commit-range=#{options.commit_range.join('...')}",
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
            'pushd packer-templates && ' \
              "git checkout -qf #{options.commit_range.last} ; " \
              'popd',
            './packer-templates/bin/packer-build-install'
          ],
          script: "./packer-templates/bin/packer-build-script #{template}"
        }
      }
    end

    def triggerable_templates
      detectors.map { |d| d.detect(changed_files) }.flatten.sort.uniq
    end

    def changed_files
      return options.trigger_paths unless options.trigger_paths.empty?
      commit_range_diff_files
    end

    def commit_range_diff_files
      git.gtree(options.commit_range.first)
         .diff(options.commit_range.last)
         .name_status.select { |_, status| %w(M A).include?(status) }
         .map { |f, _| File.expand_path(f, options.git_working_copy) }
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

  class TriggerOptions
    attr_accessor :chef_cookbook_path, :packer_templates_path,
                  :git_working_copy, :trigger_paths, :repo_slug,
                  :travis_api_url, :travis_api_token, :branch,
                  :commit_range, :builders, :noop, :quiet
  end

  class TriggerRequest
    attr_accessor :url, :body, :headers
  end
end
