require 'yaml'

class ImageMetadata
  def initialize(tarball: nil, env: nil, logger: nil)
    @tarball = tarball
    @env = env
    @logger = logger
  end

  def parent_dir
    @parent_dir ||= File.dirname(File.expand_path(tarball))
  end

  def valid?
    !tarball.nil? && File.exist?(tarball)
  end

  def load!
    load_job_board_register_yml
    extract_tarball
    load_image_metadata
    env.to_hash
  end

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
    system(*extract_command)
  end

  def extract_command
    %W(tar -C #{relbase} -xjvf #{File.expand_path(tarball)})
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
    @dir ||= File.join(
      relbase, File.basename(tarball, '.tar.bz2')
    )
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
end
