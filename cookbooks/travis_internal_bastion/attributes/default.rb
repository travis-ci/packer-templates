include_attribute 'travis_internal_base'

override['openssh']['client']['10.10.*']['user_known_hosts_file'] = '/dev/null'
override['openssh']['client']['10.10.*']['strict_host_key_checking'] = 'no'
override['openssh']['server']['permit_tunnel'] = 'no'
override['openssh']['server']['allow_tcp_forwarding'] = 'no'
override['openssh']['server']['force_command'] = '/usr/sbin/login_duo'
override['openssh']['server']['kex_algorithms'] = %w(
  curve25519-sha256@libssh.org
  diffie-hellman-group-exchange-sha256
).join(',')
override['openssh']['server']['m_a_cs'] = %w(
  hmac-sha2-512-etm@openssh.com
  hmac-sha2-256-etm@openssh.com
  hmac-ripemd160-etm@openssh.com
  umac-128-etm@openssh.com
  hmac-sha2-512
  hmac-sha2-256
  hmac-ripemd160
  umac-128@openssh.com
).join(',')
