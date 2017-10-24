# frozen_string_literal: true

default['travis_packer_templates']['env']['PACKER_BUILDER_TYPE'] = ''
default['travis_packer_templates']['env']['PACKER_BUILD_NAME'] = ''
default['travis_packer_templates']['env']['PACKER_TEMPLATES_BRANCH'] = ''
default['travis_packer_templates']['env']['PACKER_TEMPLATES_SHA'] = ''
default['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_BRANCH'] = ''
default['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_DIR'] = \
  '/tmp/chef-stuff/travis-cookbooks'
default['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_SHA'] = ''

default['travis_packer_templates']['job_board']['languages'] = []
default['travis_packer_templates']['job_board']['features'] = []
default['travis_packer_templates']['job_board']['stack'] = "unset-#{Time.now.to_i}"

default['travis_packer_templates']['packages'] = []
default['travis_packer_templates']['packages_file'] = '/var/tmp/packages.txt'
default['travis_packer_templates']['packer_env_dir'] = '/.packer-env'
default['travis_packer_templates']['job_board_register_yml'] = '/.job-board-register.yml'
default['travis_packer_templates']['node_attributes_yml'] = '/.node-attributes.yml'
