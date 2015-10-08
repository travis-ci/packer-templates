default['travis_packer_templates']['packer_env_dir'] = '/var/tmp/packer-env'
default['travis_packer_templates']['env']['PACKER_BUILD_NAME'] = ''
default['travis_packer_templates']['env']['PACKER_BUILDER_TYPE'] = ''

::Dir.glob("#{node['travis_packer_templates']['packer_env_dir']}/*") do |f|
  attr_name = ::File.basename(f)
  attr_value = ::File.read(f).strip
  next if attr_value.empty?

  default['travis_packer_templates']['env'][attr_name] = attr_value
end
