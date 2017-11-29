# frozen_string_literal: true

require 'fileutils'
require 'tmpdir'
require 'yaml'

class MacosImageMetadataWriter
  def initialize(image_name: '', osx_image: '', is_default: false)
    @image_name = image_name
    @osx_image = osx_image
    @is_default = is_default
  end

  attr_reader :image_name, :osx_image, :is_default
  private :image_name
  private :osx_image
  private :is_default

  def write(tarball_dest)
    # TODO: write {something} that passes along is_default

    tmp_dir = Dir.mktmpdir(%w[job-board-registrar-macos- -tmp])
    metadata_dir = File.join(tmp_dir, File.basename(tarball_dest, '.tar.bz2'))
    FileUtils.mkdir_p(metadata_dir)

    File.write(
      File.join(metadata_dir, 'job-board-register.yml'),
      YAML.dump(job_board_register_hash)
    )

    env_dir = File.join(metadata_dir, 'env')
    FileUtils.mkdir_p(env_dir)

    {
      'DIST' => 'macos',
      'IMAGE_NAME' => image_name,
      'PACKER_BUILDER_TYPE' => 'vmware'
    }.each do |key, value|
      File.write(File.join(env_dir, key), value)
    end

    Dir.chdir(tmp_dir) do
      `tar -cjf #{tarball_dest} #{File.basename(metadata_dir)}`
    end
  ensure
    FileUtils.rm_rf(tmp_dir) unless tmp_dir.nil?
  end

  private def job_board_register_hash
    {
      'tags' => {
        'os' => 'osx'
      },
      'tags_string' => "os:osx,osx_image:#{osx_image}"
    }
  end
end
