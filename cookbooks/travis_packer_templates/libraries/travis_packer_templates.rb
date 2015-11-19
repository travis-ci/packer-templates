require 'chef'

class TravisPackerTemplates
  attr_reader :node, :run_context

  def initialize(node, run_context)
    @node = node
    @run_context = run_context
  end

  def init!
    import_packer_env_vars
    set_group_based_on_packer_env_vars
    set_system_info_cookbooks_sha
    write_job_board_register_metadata
    set_packages_from_packages_file
    install_packages_from_packages
  end

  private

  def import_packer_env_vars
    ::Dir.glob("#{node['travis_packer_templates']['packer_env_dir']}/*") do |f|
      attr_name = ::File.basename(f)
      attr_value = ::File.read(f).strip
      next if attr_value.empty?
      Chef::Log.info("Setting travis_packer_templates.env.#{attr_name} = #{attr_value}")
      node.set['travis_packer_templates']['env'][attr_name] = attr_value
    end
  end

  def set_group_based_on_packer_env_vars
    return unless matches_edge_criteria?(node['travis_packer_templates']['env'])

    Chef::Log.info('Setting travis_packer_templates.job_board.group = edge')
    node.set['travis_packer_templates']['job_board']['group'] = 'edge'
  end

  def matches_edge_criteria?(env)
    env['TRAVIS_COOKBOOKS_BRANCH'] == 'master' &&
      env['TRAVIS_COOKBOOKS_SHA'] == '' &&
      env['PACKER_TEMPLATES_BRANCH'] == 'master' &&
      env['PACKER_TEMPLATES_SHA'] !~ /dirty/
  end

  def set_system_info_cookbooks_sha
    sha = node['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_SHA'].to_s
    Chef::Log.info("Setting system_info.cookbooks_sha = #{sha.inspect}")
    node.set['system_info']['cookbooks_sha'] = sha
  end

  def write_job_board_register_metadata
    template = Chef::Resource::Template.new(
      '/etc/default/job-board-register', run_context
    )
    template.source 'etc-default-job-board-register.sh.erb'
    template.cookbook 'travis_packer_templates'
    template.owner 'root'
    template.group 'root'
    template.mode 0644
    template.variables(
      dist: node['travis_packer_templates']['job_board']['dist'],
      group: node['travis_packer_templates']['job_board']['group'],
      branch: node['travis_packer_templates']['env']['PACKER_TEMPLATES_BRANCH'],
      languages: node['travis_packer_templates']['job_board']['languages']
    )
    template.run_action(:create)
  end

  def set_packages_from_packages_file
    packages_file = node['travis_packer_templates']['packages_file']
    if ::File.exist?(packages_file)
      packages_lines = ::File.readlines(packages_file)
      packages = packages_lines.map(&:strip).reject { |l| l =~ /^#/ }.uniq
      node.set['travis_packer_templates']['packages'] = packages
      Chef::Log.info("Loaded #{packages.length} packages from #{packages_file}")
    else
      Chef::Log.info("No file found at #{packages_file}")
    end
  end

  def install_packages_from_packages
    Array(node['travis_packer_templates']['packages']).each_slice(10) do |slice|
      resource = Chef::Resource::Package.new(slice, run_context)
      resource.retries 2
      resource.action [:install, :upgrade]
    end
  end
end
