# frozen_string_literal: true

require 'optparse'

require_relative 'env'

class MacosTarballer
  def generate!(argv: argv)
    parse_argv!(argv)
    create_contents!
  end

  private def parse_argv!(argv)
    OptionParser.new do |opts|
      opts.on(
        '-n', '--image-name=IMAGE_NAME', String, 'name of the image'
      ) do |v|
        options[:image_name] = v.strip
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
    image_metadata = ImageMetadata.new(
      # stuffff
    )

    '/some/nonexistent/thing.tar.bz2'
  end

  private def options
    @options ||= {
      osx_image: 'notset'
    }
  end

  private def env
    @env ||= Env.new
  end
end
