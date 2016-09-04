include_attribute 'travis_internal_base'

override['openssh']['server']['permit_tunnel'] = 'no'
override['openssh']['server']['allow_tcp_forwarding'] = 'no'
override['openssh']['server']['force_command'] = '/usr/sbin/login_duo'
