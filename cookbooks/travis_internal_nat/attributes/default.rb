# frozen_string_literal: true

include_attribute 'travis_internal_base'

override['openssh']['server']['force_command'] = '/usr/sbin/login_duo'
override['openssh']['server']['log_level'] = 'VERBOSE'
override['openssh']['server']['permit_tunnel'] = 'no'

default['travis_internal_nat']['nat_conntracker']['clone_dir'] = '/usr/local/src/nat-conntracker'
default['travis_internal_nat']['nat_conntracker']['git_repo'] = 'https://github.com/travis-ci/nat-conntracker.git'
default['travis_internal_nat']['nat_conntracker']['git_rev'] = 'master'
