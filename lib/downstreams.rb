require 'English'

require 'json'
require 'net/https'
require 'optparse'
require 'uri'

require 'git'

class Downstreams
  def self.trigger!
    new.trigger
  end

  def trigger
    ret = 0
    http = build_http
    build_requests.each do |template, request|
      response = http.request(request)
      if response.code < '299'
        puts "Triggered template=#{template} repo=#{repo_slug}"
        next
      end

      if response.content_type =~ /\bjson\b/
        puts JSON.parse(response.body).fetch('error', '???')
      else
        puts response.body
      end
      ret = 1
    end
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
    files = []
    last_commit_name_status.each do |filename, status|
      next unless %w(M A).include?(status)
      next if filename.start_with?('.')
      next if filename.include?('/')
      files << filename if filename =~ /\.yml$/
    end

    files.map { |f| File.basename(f, '.yml') }
  end

  def last_commit_name_status
    git.log(1).first.diff_parent.name_status
  end

  def git
    Git.open(File.expand_path('../../', __FILE__))
  end
end
