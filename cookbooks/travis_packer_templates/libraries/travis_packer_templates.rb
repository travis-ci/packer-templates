require 'chef'

class TravisPackerTemplates
  attr_reader :node

  def initialize(node)
    @node = node
  end

  def init!
    import_packer_env_vars
    set_travis_system_info_cookbooks_sha
    packages_file = node['travis_packer_templates']['packages_file']
    if ::File.exist?(packages_file)
      set_packages_from_packages_file
    else
      Chef::Log.info("No file found at #{packages_file}")
    end
  end

  private

  def import_packer_env_vars
    ::Dir.glob("#{node['travis_packer_templates']['packer_env_dir']}/*") do |f|
      attr_name = ::File.basename(f)
      attr_value = ::File.read(f).strip
      next if attr_value.empty?
      Chef::Log.info(
        "Setting travis_packer_templates.env.#{attr_name} = #{attr_value}"
      )
      node.set['travis_packer_templates']['env'][attr_name] = attr_value
    end
  end

  def set_travis_system_info_cookbooks_sha
    sha = node['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_SHA'].to_s
    Chef::Log.info("Setting travis_system_info.cookbooks_sha = #{sha.inspect}")
    node.set['travis_system_info']['cookbooks_sha'] = sha
  end

  def set_packages_from_packages_file
    packages_lines = ::File.readlines(packages_file)
    packages = packages_lines.map(&:strip).reject { |l| l =~ /^#/ }.uniq
    node.set['travis_packer_templates']['packages'] = packages
    Chef::Log.info("Loaded #{packages.length} packages from #{packages_file}")
  end
end
