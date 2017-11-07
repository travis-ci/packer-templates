# frozen_string_literal: true

describe 'sshd configuration' do
  describe command('sudo sshd -T') do
    its(:stdout) { should include(*EXPECTED_SSHD_CONFIG) }
  end
end

EXPECTED_SSHD_CONFIG = <<~EOF.split("\n")
  addressfamily any
  authorizedkeysfile .ssh/authorized_keys .ssh/authorized_keys2
  challengeresponseauthentication no
  ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
  clientalivecountmax 3
  clientaliveinterval 0
  hostkeyalgorithms ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519,rsa-sha2-512,rsa-sha2-256,ssh-rsa
  ignorerhosts yes
  ignoreuserknownhosts no
  kerberosauthentication no
  kerberosorlocalpasswd yes
  kerberosticketcleanup yes
  passwordauthentication no
  printmotd yes
  strictmodes yes
  tcpkeepalive yes
  uselogin no
  xauthlocation /usr/bin/xauth
EOF
