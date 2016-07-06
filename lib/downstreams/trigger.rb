require 'English'

require 'fileutils'
require 'json'
require 'logger'
require 'net/https'
require 'optparse'
require 'uri'

require 'faraday'
require 'git'

module Downstreams
  class Trigger
    def self.run!(argv: ARGV)
      new.run(argv: argv)
    end

    def run(argv: ARGV)
      setup(argv)

      ret = 0
      triggered = 0
      errored = 0
      http = build_http

      build_requests.each do |template, request|
        if options.noop
          log.info "Not triggering template=#{template} " \
                   "repo=#{options.target_repo_slug}"
          next
        end

        response = http.post do |req|
          req.url request.url
          req.headers.merge!(request.headers)
          req.body = request.body
        end

        if response.status < 299
          log.info "Triggered template=#{template} " \
                   "repo=#{options.target_repo_slug}"
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

    private

    def build_requests
      requests = []
      triggerable_templates.each do |template|
        request = Request.new.tap do |req|
          req.url = File.join(
            '/repo', URI.escape(options.target_repo_slug, '/'), 'requests'
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

    def setup(argv)
      return if @setup
      parse_args(argv)
      options.packer_templates_path ||= default_packer_templates_path
      options.chef_cookbook_path ||= default_chef_cookbook_path
      if options.root_repo.nil? || options.root_repo.empty?
        options.root_repo_dir =
          options.packer_templates_path.first.repo.repo.path
      end
      @setup = true
    end

    def parse_args(argv)
      OptionParser.new do |opts|
        opts.on('-r GIT_REMOTE', '--root-repo GIT_REMOTE',
                'Git remote of root repository to check commit range. ' \
                'defaults to the first entry of --packer-templates-path') do |v|
          options.root_repo = v.strip
        end

        opts.on('-R GIT_DIR', '--root-repo-dir GIT_DIR',
                'Git dir of root repository to check commit range. ' \
                'defaults to the first entry of --packer-template-path') do |v|
          options.root_repo_dir = File.expand_path(v.strip)
        end

        opts.on('-P GITFUL_PATH', '--packer-templates-path GITFUL_PATH',
                'Packer templates path. ' \
                "default=#{default_packer_templates_path_string}") do |v|
          options.packer_templates_path = parse_git_remote_path(
            v, options.clone_tmp
          )
        end

        opts.on('-t REPO', '--target-repo-slug REPO',
                'Target repo slug to which triggered builds should be sent. ' \
                "default=#{options.target_repo_slug}") do |v|
          options.target_repo_slug = v.strip
        end

        opts.on('-u URL', '--travis-api-url URL',
                'URL of the Travis API to which triggered builds should ' \
                "be sent. default=#{options.travis_api_url}") do |v|
          options.travis_api_url = URI(v)
        end

        opts.on('-T TOKEN', '--travis-api-token TOKEN',
                'API token for use with Travis API.') do |v|
          options.travis_api_token = v.strip
        end

        opts.on('-C COMMIT_RANGE', '--commit-range COMMIT_RANGE',
                'Commit range to check for changed paths. ' \
                "default=#{options.commit_range}") do |v|
          options.commit_range = v.strip.split('...').map(&:strip)
        end

        opts.on('-B BRANCH', '--branch BRANCH',
                'Branch name to clone of root repository in triggered build. ' \
                "default=#{options.branch}") do |v|
          options.branch = v.strip
        end

        opts.on('-D CLONE_TMP', '--clone-tmp CLONE_TMP',
                'Temporary directory for git clones. ' \
                "default=#{options.clone_tmp}") do |v|
          options.clone_tmp = v.strip
        end

        opts.on('-b BUILDERS', '--builders BUILDERS',
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

        opts.on('-c GITFUL_PATH', '--chef-cookbook-path GITFUL_PATH',
                'Cookbook path. ' \
                "default=#{default_chef_cookbook_path_string}") do |v|
          options.chef_cookbook_path = parse_git_remote_path(
            v, options.clone_tmp
          )
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          puts "\n\n"
          puts <<-EOF.gsub(/^\s+> ?/, '')
            > Options that accept a `GITFUL_PATH` type expect the string
            > arguments to contain whitespace-separated tokens of the format:
            >
            >     <git-repo-remote>:[prefix],[prefix...]
            >
            > e.g.:
            >
            >     https://github.com/repo/remote.git::cookbooks@master,ci_environment@precise-stable
            >     git@github.com:other/remote.git::
            >
            > This allows for arguments like packer templates paths and cookbook
            > paths to contain multiple entries for a given git repository,
            > while retaining a prefix "namespace" for purposes of matching file
            > paths.
            >
            > Leading '/' characters are automatically stripped from repository
            > prefixes, as git lists files without leading slashes.
          EOF
          exit 0
        end
      end.parse!(argv)
    end

    def options
      @options ||= Options.new.tap do |opts|
        opts.root_repo = ENV.fetch('ROOT_REPO', '')
        opts.target_repo_slug = ENV.fetch(
          'TARGET_REPO_SLUG', 'travis-ci/packer-build'
        )
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
        opts.clone_tmp = ENV.fetch(
          'CLONE_TMP', File.join(Dir.tmpdir, 'downstreams-clones')
        )

        opts.builders = ENV.fetch(
          'BUILDERS', 'amazon-ebs,googlecompute,docker'
        ).split(',').map(&:strip)
        opts.noop = ENV['NOOP'] == '1'
        opts.quiet = ENV['QUIET'] == '1'
      end
    end

    def parse_git_remote_path(string, clone_tmp)
      entries = string.split(/\s+/).map do |segment|
        repo_remote, paths = segment.split('::')
        paths = '/' unless paths
        local_clone = File.join(repo_remote, '.git')

        if File.directory?(local_clone)
          repo_remote = Git.bare(local_clone).remotes
                           .select { |remote| remote.name == 'origin' }
                           .first.url
        else
          local_clone = File.join(
            clone_tmp, clone_basename(repo_remote)
          )
        end

        if File.directory?(local_clone)
          git = Git.bare(local_clone)
          git.fetch
        else
          git = Git.clone(repo_remote, local_clone, bare: true)
        end

        paths.split(',').map do |path_entry|
          entry, ref = path_entry.split('@').map(&:strip)
          ref = 'HEAD' unless ref
          Downstreams::GitPath.new(git, entry.sub(%r{^/}, ''), ref)
        end
      end

      entries.flatten
    end

    def default_packer_templates_path
      parse_git_remote_path(
        default_packer_templates_path_string, options.clone_tmp
      )
    end

    def default_packer_templates_path_string
      ENV.fetch(
        'PACKER_TEMPLATES_PATH',
        "#{File.expand_path('../../../', __FILE__)}::"
      )
    end

    def default_chef_cookbook_path
      parse_git_remote_path(
        default_chef_cookbook_path_string, options.clone_tmp
      )
    end

    def default_chef_cookbook_path_string
      ENV.fetch(
        'CHEF_COOKBOOK_PATH',
        "#{File.expand_path('../../../', __FILE__)}::cookbooks"
      )
    end

    def default_root_repo_dir
      File.expand_path(
        ENV.fetch('ROOT_REPO_DIR', File.join(Dir.getwd, '.git'))
      )
    end

    def detectors
      @detectors ||= [
        Downstreams::ChefDetector.new(
          options.chef_cookbook_path,
          options.packer_templates_path
        ),
        Downstreams::FileDetector.new(
          options.packer_templates_path
        ),
        Downstreams::ShellDetector.new(
          options.packer_templates_path
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
      root_repo_commit_range_diff_files
    end

    def root_repo_commit_range_diff_files
      root_repo_git.gtree(options.commit_range.first)
                   .diff(options.commit_range.last)
                   .name_status.select { |_, status| %w(M A).include?(status) }
                   .map do |f, _|
        Downstreams::GitPath.new(root_repo_git, f, options.commit_range.last)
      end
    end

    def root_repo_git
      Git.bare(root_repo_dir)
    end

    def root_repo_dir
      return options.root_repo_dir if options.root_repo_dir &&
                                      File.exist?(options.root_repo_dir)
      clone_root_repo
    end

    def root_repo_origin_url
      root_repo_git.remotes
                   .select { |remote| remote.name == 'origin' }.first.url
    end

    def clone_basename(repo_remote)
      URI.escape(repo_remote, '@:/.') + '.git'
    end

    def clone_root_repo
      dest = File.join(clone_tmp, '__root__.git')

      if File.directory?(dest)
        Git.bare(dest).fetch('origin')
        return dest
      end

      Git.clone(options.root_repo, dest, bare: true)

      dest
    end

    def clone_tmp
      return @clone_tmp if @clone_tmp && File.directory?(@clone_tmp)
      FileUtils.mkdir_p(options.clone_tmp)
      @clone_tmp = options.clone_tmp
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

    class Options
      attr_accessor :chef_cookbook_path, :packer_templates_path,
                    :root_repo, :root_repo_dir, :target_repo_slug,
                    :travis_api_url, :travis_api_token, :branch,
                    :commit_range, :clone_tmp, :builders, :noop, :quiet
    end

    class Request
      attr_accessor :url, :body, :headers
    end
  end
end
