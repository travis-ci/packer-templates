# frozen_string_literal: true

require 'logger'
require 'pathname'
require 'yaml'

class ImageMetadata
  def initialize(tarball: '', env: nil, url: '', logger: nil)
    @tarball = tarball
    @env = env
    @url = url
    @logger = logger
    @env_hash = nil
    @files = {}
  end

  def parent_dir
    @parent_dir ||= File.dirname(File.expand_path(tarball))
  end

  def valid?
    !tarball.nil? && File.exist?(tarball)
  end

  def load!
    extract_tarball
    load_job_board_register_yml
    load_image_metadata

    @env_hash = env.to_hash
    @files = {}

    return unless dir.exist?

    dir.children.reject { |c| !c.exist? || c.directory? }.each do |p|
      @files[p.basename.to_s] = p
    end
  end

  attr_reader :env_hash, :files, :tarball, :tarball_files, :url, :env
  alias to_s tarball

  def job_board_register_hash
    YAML.load_file(job_board_register_yml)
  end

  def tarball_files
    @tarball_files ||= begin
      `tar -tf #{tarball}`.split("\n")
                          .map(&:strip)
                          .reject { |p| p.end_with?('/') }
                          .map do |p|
        p.sub(%r{#{File.basename(tarball, '.tar.bz2')}/}, '')
      end
    end
  end

  private def relbase
    @relbase ||= File.dirname(tarball)
  end

  private def load_job_board_register_yml
    loaded = job_board_register_hash
    env['OS'] = loaded['tags']['os']
    env['DIST'] = loaded['tags']['dist']
    env['TAGS'] = loaded['tags_string']
  end

  private def job_board_register_yml
    @job_board_register_yml ||= File.join(dir, 'job-board-register.yml')
  end

  private def extract_tarball
    system(*extract_command, out: '/dev/null')
  end

  private def extract_command
    %W[tar -C #{relbase} -xjf #{File.expand_path(tarball)}]
  end

  private def load_image_metadata
    if envdir_isdir?
      env.load_envdir(envdir) do |key, _|
        logger.debug "loading #{key}"
      end
    else
      logger.warn "#{envdir} does not exist"
    end
  end

  private def dir
    @dir ||= Pathname.new(
      File.join(relbase, File.basename(tarball, '.tar.bz2'))
    )
  end

  private def tarball_exists?
    File.exist?(tarball)
  end

  private def envdir_isdir?
    File.directory?(envdir)
  end

  private def envdir
    @envdir ||= File.join(dir, 'env')
  end

  private def logger
    @logger ||= Logger.new($stdout)
  end
end
