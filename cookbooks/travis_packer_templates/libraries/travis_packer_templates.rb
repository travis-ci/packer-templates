# frozen_string_literal: true

require 'json'
require 'yaml'
require 'fileutils'

require 'chef'

class TravisPackerTemplates
  attr_reader :node, :init_time

  def initialize(node)
    @node = node
    @init_time = Time.now.utc
  end

  def init!(init_time)
    @init_time = init_time
    import_packer_env_vars
    assign_travis_system_info_cookbooks_sha(
      node['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_SHA'].to_s
    )
    packages_file = node['travis_packer_templates']['packages_file']
    if ::File.exist?(packages_file)
      assign_packages_from_packages_file(packages_file)
    else
      Chef::Log.info("No file found at #{packages_file}")
    end
  end

  def write_node_attributes_yml
    node_attributes_hash = lil_hash(node.attributes.to_hash)
    raise 'Empty node attributes' if node_attributes_hash.keys.empty?

    write_yml(
      node['travis_packer_templates']['node_attributes_yml'],
      node_attributes_hash.merge('__timestamp' => init_time.to_s)
    )
  end

  def write_job_board_register_yml
    job_board_attrs = lil_hash(
      node['travis_packer_templates']['job_board'].to_hash
    )
    raise 'Empty job-board attributes' if job_board_attrs.keys.empty?

    job_board_attrs['tags'] = job_board_tags(job_board_attrs)
    job_board_attrs['tags_string'] = Array(
      job_board_attrs['tags']
    ).sort.map { |k, v| "#{k}:#{v}" }.join(',')

    write_yml(
      node['travis_packer_templates']['job_board_register_yml'],
      job_board_attrs
    )
  end

  private

  def job_board_tags(job_board_attrs)
    tags = {
      'dist' => node['lsb']['codename'].to_s,
      'os' => node['os'].to_s,
      'packer_chef_time' => init_time.strftime('%Y%m%dT%H%M%SZ')
    }

    %w[language feature].each do |prefix|
      job_board_attrs["#{prefix}s"].each do |value|
        tags["#{prefix}_#{value}"] = true
      end
    end

    tags
  end

  def lil_hash(hash)
    JSON.parse(JSON.dump(hash))
  end

  def write_yml(outfile, content,
                owner: default_owner, group: default_group, mode: 0o644)
    File.open(outfile, 'w') do |f|
      f.puts YAML.dump(content)
    end

    FileUtils.chown(owner, group, outfile)
    FileUtils.chmod(mode, outfile)
  end

  def default_owner
    @default_owner ||= 'root'
  end

  def default_group
    @default_group ||= 'root'
  end

  def import_packer_env_vars
    ::Dir.glob("#{node['travis_packer_templates']['packer_env_dir']}/*") do |f|
      attr_name = ::File.basename(f)
      attr_value = ::File.read(f).strip
      next if attr_value.empty?

      Chef::Log.info(
        "Setting travis_packer_templates.env.#{attr_name}"
      )
      node.override['travis_packer_templates']['env'][attr_name] = attr_value
    end
  end

  def assign_travis_system_info_cookbooks_sha(sha)
    Chef::Log.info('Setting travis_system_info.cookbooks_sha')
    node.override['travis_system_info']['cookbooks_sha'] = sha
  end

  def assign_packages_from_packages_file(packages_file)
    packages_lines = ::File.readlines(packages_file)
    packages = packages_lines.map(&:strip).reject { |l| l =~ /^#/ }.uniq
    node.override['travis_packer_templates']['packages'] = packages
    Chef::Log.info("Loaded #{packages.length} packages from #{packages_file}")
  end
end
