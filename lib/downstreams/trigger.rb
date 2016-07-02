require 'English'

require 'json'
require 'net/https'
require 'optparse'
require 'uri'
require 'logger'

require 'git'

module Downstreams
  class Trigger
    Options = Struct.new(
      :cookbook_path,
      :packer_templates,
      :noop,
      :git_working_copy
    )

    def self.run!(argv: ARGV)
      new.run(argv: argv)
    end

    def run(argv: ARGV)
      OptionParser.new do |opts|
        opts.on('-pPATH', '--cookbook-path=PATH',
                'Cookbook path (":"-delimited). ' \
                "default=#{options.cookbook_path}") do |v|
          options.cookbook_path = parse_cookbook_path(v)
        end

        opts.on('-tDIR', '--packer-templates=DIR',
                'Packer templates base directory. ' \
                "default=#{options.packer_templates}") do |v|
          options.packer_templates = File.expand_path(v.strip)
        end

        opts.on('-n', '--noop', 'Do not do') do
          options.noop = true
        end

        opts.on('-gDIR', '--git-working-copy=DIR',
                'Root of git working copy to check. ' \
                "default=#{options.git_working_copy}") do |v|
          options.git_working_copy = File.expand_path(v.strip)
        end
      end.parse!(argv)

      ret = 0
      triggered = 0
      errored = 0
      http = build_http

      build_requests.each do |template, request|
        if options.noop
          log.info "Not triggering template=#{template} repo=#{repo_slug}"
          next
        end

        response = http.request(request)
        if response.code < '299'
          log.info "Triggered template=#{template} repo=#{repo_slug}"
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
      templates.map do |template|
        request = Net::HTTP::Post.new(
          File.join('/repo', URI.escape(repo_slug, '/'), 'requests'),
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'Travis-API-Version' => '3',
          'Authorization' => "token #{travis_api_token}"
        )
        request.body = JSON.dump(body(template))
        [template, request]
      end
    end

    def build_http
      Net::HTTP.new(travis_api.host, travis_api.port).tap do |http|
        if travis_api.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        end
      end
    end

    private

    def options
      @options ||= Options.new(
        parse_cookbook_path(
          ENV.fetch(
            'COOKBOOK_PATH',
            File.expand_path('../../../cookbooks', __FILE__)
          )
        ),
        File.expand_path(
          ENV.fetch(
            'PACKER_TEMPLATES',
            File.expand_path('../../../', __FILE__)
          )
        ),
        false,
        File.expand_path(
          ENV.fetch(
            'GIT_WORKING_DIR',
            File.expand_path('../../../', __FILE__)
          )
        )
      )
    end

    def parse_cookbook_path(string)
      string.split(':').map do |p|
        File.expand_path(p.strip)
      end
    end

    def detector
      @detector ||= Downstreams::Detector.new(
        options.cookbook_path,
        options.packer_templates
      )
    end

    def body(template)
      {
        message: ":lemon: :bomb: origin-commit=#{commit}",
        branch: template,
        config: {
          language: 'generic',
          dist: 'trusty',
          group: 'edge',
          sudo: true,
          env: {
            matrix: builders.map { |b| "BUILDER=#{b}" }
          },
          install: [
            "git clone --branch=#{branch} " \
              'https://github.com/travis-ci/packer-templates.git',
            "pushd packer-templates && git checkout -qf #{commit} ; popd",
            './packer-templates/bin/packer-build-install'
          ],
          script: "./packer-templates/bin/packer-build-script #{template}"
        }
      }
    end

    def repo_slug
      # TODO: make configurable?
      'travis-ci/packer-build'
    end

    def travis_api
      @travis_api ||= URI(ENV.fetch('TRAVIS_API_URL', 'https://api.travis-ci.org'))
    end

    def travis_api_token
      ENV['TRAVIS_API_TOKEN']
    end

    def commit
      ENV['TRAVIS_COMMIT']
    end

    def branch
      ENV['TRAVIS_BRANCH']
    end

    def builders
      # TODO: define this dynamically
      %w(amazon-ebs googlecompute docker)
    end

    def templates
      detector.detect(changed_files)
    end

    def changed_files
      # TODO: replace this with better diff check?  Account for PR?
      last_commit_name_status.select do |_, status|
        %w(M A).include?(status)
      end.map { |filename, _| filename }
    end

    def last_commit_name_status
      git.log(1).first.diff_parent.name_status
    end

    def git
      Git.open(options.git_working_copy)
    end

    def log
      @log ||= Logger.new($stdout).tap do |l|
        l.progname = File.basename($PROGRAM_NAME)
        l.formatter = proc do |_, _, progname, msg|
          "#{progname}: #{msg}\n"
        end
      end
    end
  end
end
