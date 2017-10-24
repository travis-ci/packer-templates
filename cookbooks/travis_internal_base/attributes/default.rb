# frozen_string_literal: true

override['openssh']['client']['10.*']['strict_host_key_checking'] = 'no'
override['openssh']['client']['10.*']['user_known_hosts_file'] = '/dev/null'
override['openssh']['server']['allow_tcp_forwarding'] = 'no'
override['openssh']['server']['challenge_response_authentication'] = 'no'
override['openssh']['server']['listen_address'] = %w(0.0.0.0:22 [::]:22)
override['openssh']['server']['match']['Host *']['password_authentication'] = 'no'
override['openssh']['server']['match']['Host *']['pubkey_authentication'] = 'yes'
override['openssh']['server']['password_authentication'] = 'no'
override['openssh']['server']['permit_root_login'] = 'no'
override['openssh']['server']['protocol'] = '2'
override['openssh']['server']['pubkey_authentication'] = 'yes'
override['openssh']['server']['kex_algorithms'] = %w[
  curve25519-sha256@libssh.org
  diffie-hellman-group-exchange-sha256
].join(',')
override['openssh']['server']['host_key'] = %w[
  /etc/ssh/ssh_host_ed25519_key
  /etc/ssh/ssh_host_rsa_key
]
override['openssh']['server']['ciphers'] = %w[
  chacha20-poly1305@openssh.com
  aes256-gcm@openssh.com
  aes128-gcm@openssh.com
  aes256-ctr
  aes192-ctr
  aes128-ctr
].join(',')
override['openssh']['server']['m_a_cs'] = %w[
  hmac-sha2-512-etm@openssh.com
  hmac-sha2-256-etm@openssh.com
  hmac-ripemd160-etm@openssh.com
  umac-128-etm@openssh.com
  hmac-sha2-512
  hmac-sha2-256
  hmac-ripemd160
  umac-128@openssh.com
].join(',')

override['travis_sudo']['groups'] = %w[sudo]
