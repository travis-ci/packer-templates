# frozen_string_literal: true

describe 'sshd configuration' do
  describe command('sudo sshd -T') do
    its(:stdout) { should include(*EXPECTED_SSHD_CONFIG) }
  end
end

EXPECTED_SSHD_CONFIG = <<~EOF.split("\n")
  addressfamily any
  clientaliveinterval 0
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
