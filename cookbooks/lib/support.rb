lib = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

module Support
  autoload :Helpers, 'support/helpers'
  autoload :JobBoardTags, 'support/job_board_tags'
  autoload :Python, 'support/python'

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
end
