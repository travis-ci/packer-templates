require 'logger'
require 'uri'

class JobBoardRegistrar
  def initialize(image_metadata_tarball)
    @image_metadata_tarball = image_metadata_tarball
  end

  def register!
    if image_metadata_tarball.nil?
      logger.error 'missing image metadata tarball'
      return 1
    end

    load_envdir(job_board_envdir)

    if env('JOB_BOARD_IMAGES_URL').empty?
      logger.error 'missing $JOB_BOARD_IMAGES_URL'
      return 1
    end

    if env('IMAGE_NAME').empty?
      logger.error 'missing $IMAGE_NAME'
      return 1
    end

    unless image_metadata_tarball_exists?
      logger.error 'image metadata tarball does not exist'
      return 1
    end

    unless extract_image_metadata_tarball
      logger.error 'failed to extract image metadata tarball'
      return 1
    end

    load_image_metadata
    dump_relevant_env_vars

    return 0 if make_request
    1
  end

  private

  attr_reader :image_metadata_tarball, :image_infra

  def make_request
    output = `#{request_command.join(' ')}`.strip
    $stdout.puts JSON.pretty_generate(JSON.parse(output))
    true
  rescue => e
    logger.error e
    false
  end

  def request_command
    %W(
      #{curl_exe}
      -f
      -s
      -X POST
      '#{env('JOB_BOARD_IMAGES_URL')}?#{registration_request_params}'
    )
  end

  def extract_image_metadata_tarball
    system(*image_metadata_extract_command)
  end

  def image_metadata_extract_command
    %W(tar -C #{relbase} -xjvf #{image_metadata_tarball.inspect})
  end

  def load_image_metadata
    if image_metadata_envdir_isdir?
      load_envdir(image_metadata_envdir)
    else
      logger.warn "#{image_metadata_envdir} does not exist"
    end
  end

  def dump_relevant_env_vars
    ENV.each do |key, value|
      next unless key =~ /^(PACKER|TRAVIS|TAGS|IMAGE_NAME)/
      logger.info "#{key.strip}=#{value.strip}"
    end
  end

  def registration_request_params
    {
      infra: image_infra,
      name: env('IMAGE_NAME'),
      tags: image_tags.map { |k, v| "#{k}:#{v}" }.join(',')
    }.map { |k, v| "#{k}=#{URI.escape(v)}" }.join('&')
  end

  def image_tags
    {
      os: os,
      :"group_#{group}" => 'true',
      group: group,
      dist: dist,
      packer_templates_branch: env('PACKER_TEMPLATES_BRANCH'),
      packer_templates_sha: env('PACKER_TEMPLATES_SHA'),
      travis_cookbooks_branch: env('TRAVIS_COOKBOOKS_BRANCH'),
      travis_cookbooks_sha: env('TRAVIS_COOKBOOKS_SHA')
    }.tap do |tags|
      tags[:packer_build_name] = env('PACKER_BUILD_NAME') if
        ENV.key?('PACKER_BUILD_NAME')
      tags[:packer_builder_type] = env('PACKER_BUILDER_TYPE') if
        ENV.key?('PACKER_BUILDER_TYPE')
    end
  end

  def os
    return 'osx' if RUBY_PLATFORM =~ /darwin/i
    return 'linux' if RUBY_PLATFORM =~ /linux/i
    'unknown'
  end

  def group
    return 'edge' if
      env('TRAVIS_COOKBOOKS_BRANCH') == env('TRAVIS_COOKBOOKS_EDGE_BRANCH') &&
      env('TRAVIS_COOKBOOKS_SHA') !~ /dirty/ &&
      env('PACKER_TEMPLATES_BRANCH') == 'master' &&
      env('PACKER_TEMPLATES_SHA') !~ /dirty/

    'dev'
  end

  def dist
    return `lsb_release -sc 2>/dev/null`.strip if os == 'linux'
    return `sw_vers -productVersion 2>/dev/null`.strip if os == 'osx'
    'unknown'
  end

  def image_infra
    @image_infra ||= {
      'googlecompute' => 'gce',
      'docker' => 'docker',
      'vmware' => 'jupiterbrain'
    }.fetch(env('PACKER_BUILDER_TYPE'), 'local')
  end

  def env(key)
    (ENV[key] || '').strip
  end

  def relbase
    @relbase ||= File.dirname(image_metadata_tarball)
  end

  def image_metadata_dir
    @image_metadata_dir ||= File.join(
      relbase, File.basename(image_metadata_tarball, '.tar.bz2')
    )
  end

  def image_metadata_tarball_exists?
    File.exist?(image_metadata_tarball)
  end

  def image_metadata_envdir_isdir?
    File.directory?(image_metadata_envdir)
  end

  def image_metadata_envdir
    @image_metadata_envdir ||= File.join(image_metadata_dir, 'env')
  end

  def image_job_board_env
    @image_job_board_env ||= File.join(image_metadata_dir, 'job-board-register')
  end

  def job_board_envdir
    @job_board_envdir ||= File.join(relbase, 'job-board-env')
  end

  def load_envdir(path)
    Dir.glob(File.join(path, '*')) do |entry|
      next unless File.file?(entry)
      logger.info "loading #{entry}"
      ENV[File.basename(entry)] = File.read(entry)
    end
  end

  def logger
    @logger ||= Logger.new($stdout).tap do |l|
      l.formatter = proc do |severity, datetime, _, msg|
        "time=#{datetime.utc.strftime('%Y-%m-%dT%H:%M:%SZ')} " \
          "level=#{severity.downcase} msg=#{msg.inspect}\n"
      end
    end
  end

  def curl_exe
    @curl_exe ||= ENV.fetch('CURL_EXE', 'curl')
  end
end
