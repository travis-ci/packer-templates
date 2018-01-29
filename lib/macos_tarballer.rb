# frozen_string_literal: true

require 'optparse'

require_relative 'env'
require_relative 'macos_image_metadata_writer'

class MacosTarballer
  def generate!(argv: ARGV)
    parse_argv!(argv)
    create_contents!
  end

  private def parse_argv!(argv)
    OptionParser.new do |opts|
      opts.on(
        '-n', '--image-name=IMAGE_NAME', String, 'name of the image'
      ) do |v|
        options[:image_name] = "#{v.strip}-#{image_timestamp}"
      end
      opts.on(
        '-O', '--osx-image=OSX_IMAGE', String, 'value for osx_image tag'
      ) do |v|
        options[:osx_image] = v.strip
      end
      opts.on(
        '-d', '--output-dir=OUTPUT_DIR', String,
        'output directory for the generated tarball'
      ) do |v|
        options[:output_dir] = v.strip
      end
      opts.on(
        '-D', '--[no]-is-default',
        'set the image as default for the infrastructure'
      ) do |v|
        options[:is_default] = v
      end
    end.parse!(argv)
  end

  private def create_contents!
    dest = File.join(
      options[:output_dir],
      "image-metadata-#{options[:image_name]}.tar.bz2"
    )
    MacosImageMetadataWriter.new(
      image_name: options[:image_name],
      osx_image: options[:osx_image],
      is_default: options[:is_default]
    ).write(dest)
    dest
  end

  private def image_timestamp
    @image_timestamp ||= Time.now.utc.to_i.to_s
  end

  private def options
    @options ||= {
      osx_image: 'notset',
      image_name: 'notset',
      is_default: false,
      output_dir: Dir.pwd
    }
  end

  private def env
    @env ||= Env.new
  end
end

MacosTarballer.new.generate! if $PROGRAM_NAME == __FILE__
