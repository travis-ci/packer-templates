lib = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'fileutils'
require 'pathname'
require 'tmpdir'

include FileUtils

module Support
  autoload :Erlang, 'support/erlang'
  autoload :Helpers, 'support/helpers'
  autoload :JobBoardTags, 'support/job_board_tags'
  autoload :NodeAttributes, 'support/node_attributes'
  autoload :Php, 'support/php'
  autoload :Postgresql, 'support/postgresql'
  autoload :Python, 'support/python'
  autoload :RabbitMQAdmin, 'support/rabbitmqadmin'

  def base_packages
    @base_packages ||= []

    if ::File.exist?(base_packages_file)
      @base_packages += ::File.read(
        base_packages_file
      ).split(/\n/).map(&:strip).reject { |l| l =~ /^#/ }
      @base_packages.uniq!
    end

    @base_packages
  end

  module_function :base_packages

  def base_packages_file
    ENV['TRAVIS_BASE_PACKAGES_FILE'] || '/var/tmp/packages.txt'
  end

  module_function :base_packages_file

  def attributes
    ::Support::NodeAttributes.new.load
  end

  module_function :attributes

  def libdir
    @libdir ||= Pathname.new(File.expand_path('../', __FILE__))
  end

  module_function :libdir

  def tmpdir
    @tmpdir ||= Pathname.new(Dir.mktmpdir(%w(packer-templates- -rspec)))
  end

  module_function :tmpdir
end

at_exit do
  rm_rf(Support.tmpdir)
end
