require 'English'

require 'json'
require 'net/https'
require 'optparse'
require 'uri'

class Downstreams
  def self.trigger!
    new.trigger
  end

  def trigger
    response = build_http.request(build_request)
    if response.code > '299'
      if response.content_type =~ /\bjson\b/
        puts JSON.parse(response.body).fetch('error', '???')
      else
        puts response.body
      end
      return 1
    end
    0
  end

  def build_request
    request = Net::HTTP::Post.new(
      File.join('/repo', URI.escape(repo_slug, '/'), 'requests'),
      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'Travis-API-Version' => '3',
        'Authorization' => "token #{travis_api_token}"
      }
    )
    request.body = JSON.dump(body)
    request
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

  def body
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
          'git clone --depth=50 ' \
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

  def builders
    # TODO: define this dynamically
    %w(amazon-ebs)
  end

  def template
    # TODO: define this dynamically
    'worker'
  end
end
