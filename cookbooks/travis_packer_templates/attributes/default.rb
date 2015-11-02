default['travis_packer_templates']['packer_env_dir'] = '/var/tmp/packer-env'
default['travis_packer_templates']['env']['PACKER_BUILD_NAME'] = ''
default['travis_packer_templates']['env']['PACKER_BUILDER_TYPE'] = ''
default['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_BRANCH'] = ''
default['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_SHA'] = ''
default['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_DIR'] = \
  '/tmp/chef-stuff/travis-cookbooks'

::Dir.glob("#{node['travis_packer_templates']['packer_env_dir']}/*") do |f|
  attr_name = ::File.basename(f)
  attr_value = ::File.read(f).strip
  next if attr_value.empty?

  default['travis_packer_templates']['env'][attr_name] = attr_value
end

default['travis_packer_templates']['job_board']['languages'] = []
default['travis_packer_templates']['job_board']['edge'] = (
  default['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_BRANCH'] == 'master' &&
  default['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_SHA'] == ''
)

default['travis_packer_templates']['packages'] = []
default['travis_packer_templates']['packages_file'] = '/var/tmp/packages.txt'
