# frozen_string_literal: true

require 'json'
require 'logger'
require 'uri'

require_relative 'env'
require_relative 'image_metadata'
require_relative 'image_tagger'

class JobBoardRegistrar
  def initialize(image_metadata_tarball)
    @image_metadata = ImageMetadata.new(
      tarball: image_metadata_tarball,
      env: env,
      logger: logger
    )
    @image_tagger = ImageTagger.new(env: env)
  end

  def register!
    return die('invalid image metadata') unless image_metadata.valid?

    env.load_envdir(job_board_envdir) { |k, _| logger.info "loading #{k}" }
    return die('missing $JOB_BOARD_IMAGES_URL') if
      env['JOB_BOARD_IMAGES_URL'].empty?

    image_metadata.load!
    return die('missing $IMAGE_NAME') if env['IMAGE_NAME'].empty?

    return 0 if make_request

    1
  end

  private

  attr_reader :image_metadata, :image_tagger

  def env
    @env ||= Env.new
  end

  def make_request
    output = `#{request_command.join(' ')}`.strip
    logger.info(output) unless env['JOB_BOARD_REGISTER_DEBUG'].empty?
    output = JSON.pretty_generate(JSON.parse(output)) if
      env['JOB_BOARD_NO_PARSE_RESPONSE'].empty?
    $stdout.puts output
    true
  rescue StandardError => e
    logger.error e
    false
  end

  def request_command
    %W[
      #{curl_exe}
      -f
      -s
      -X POST
      '#{env['JOB_BOARD_IMAGES_URL']}?#{registration_request_params}'
    ]
  end

  def registration_request_params
    URI.encode_www_form(
      infra: image_tagger.infra,
      name: env['IMAGE_NAME'],
      tags: image_tagger.tags.map { |k, v| "#{k}:#{v}" }.join(',')
    )
  end

  def job_board_envdir
    @job_board_envdir ||= File.join(
      image_metadata.parent_dir, 'job-board-env'
    )
  end

  def logger
    @logger ||= Logger.new($stdout).tap do |l|
      l.formatter = proc do |severity, datetime, _, msg|
        "time=#{datetime.utc.strftime('%Y-%m-%dT%H:%M:%SZ')} " \
          "level=#{severity.downcase} msg=#{msg.inspect}\n"
      end
    end
  end

  def die(*msg)
    logger.error(*msg)
    1
  end

  def curl_exe
    @curl_exe ||= ENV.fetch('CURL_EXE', 'curl')
  end
end
