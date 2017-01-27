require 'logger'
require 'yaml'

class ImageMetadata
  def initialize(tarball: nil, env: nil, logger: nil)
    @tarball = tarball
    @env = env
    @logger = logger
    @env_hash = nil
    @files = {}
  end

  def to_s
    tarball
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

    dir.children.reject(&:directory?).each do |p|
      @files[p.basename.to_s] = p
    end
  end

  attr_reader :env_hash, :files

  private

  attr_reader :tarball, :env, :logger

  def relbase
    @relbase ||= File.dirname(tarball)
  end

  def load_job_board_register_yml
    loaded = load_raw_job_board_register_yml
    env['OS'] = loaded['tags']['os']
    env['DIST'] = loaded['tags']['dist']
    env['TAGS'] = loaded['tags_string']
  end

  def load_raw_job_board_register_yml
    YAML.load_file(job_board_register_yml)
  end

  def job_board_register_yml
    @job_board_register_yml ||= File.join(dir, 'job-board-register.yml')
  end

  def extract_tarball
    system(*extract_command, out: '/dev/null')
  end

  def extract_command
    %W(tar -C #{relbase} -xjf #{File.expand_path(tarball)})
  end

  def load_image_metadata
    if envdir_isdir?
      env.load_envdir(envdir) do |key, _|
        logger.info "loading #{key}"
      end
    else
      logger.warn "#{envdir} does not exist"
    end
  end

  def dir
    @dir ||= Pathname.new(File.join(
                            relbase, File.basename(tarball, '.tar.bz2')
    ))
  end

  def tarball_exists?
    File.exist?(tarball)
  end

  def envdir_isdir?
    File.directory?(envdir)
  end

  def envdir
    @envdir ||= File.join(dir, 'env')
  end

  def logger
    @logger ||= Logger.new($stdout)
  end
end
