# frozen_string_literal: true

include_attribute 'travis_internal_base'

override['openssh']['server']['force_command'] = '/usr/sbin/login_duo'
override['openssh']['server']['log_level'] = 'VERBOSE'
override['openssh']['server']['permit_tunnel'] = 'no'
