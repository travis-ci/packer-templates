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
    env.source_file(image_job_board_env) do |key, value|
      logger.info "setting #{key}=#{value}"
    end if image_job_board_env_exists?

    extract_tarball
    load_image_metadata
    env.to_hash
  end

  private

  attr_reader :tarball, :env, :logger

  def relbase
    @relbase ||= File.dirname(tarball)
  end

  def image_job_board_env_exists?
    File.exist?(image_job_board_env)
  end

  def image_job_board_env
    @image_job_board_env ||= File.join(
      dir, 'job-board-register'
    )
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
