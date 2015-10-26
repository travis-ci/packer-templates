require 'serverspec'

set :backend, :exec
set :shell, 'bash'

class Support
  def self.base_packages
    @base_packages ||= []

    if ::File.exist?(base_packages_file)
      @base_packages += ::File.read(
        base_packages_file
      ).split(/\n/).map(&:strip).reject { |l| l =~ /^#/ }
      @base_packages.uniq!
    end

    @base_packages
  end

  def self.base_packages_file
    ENV['CI_MINIMAL_BASE_PACKAGES_FILE'] || '/var/tmp/packages.txt'
  end
end
