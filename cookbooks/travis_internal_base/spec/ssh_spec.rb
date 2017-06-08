# frozen_string_literal: true

describe 'sshd configuration' do
  describe command('sudo sshd -T') do
    its(:stdout) { should include(*EXPECTED_SSHD_CONFIG) }
  end
end

EXPECTED_SSHD_CONFIG = <<~EOF.split("\n")
  addressfamily any
  allowtcpforwarding no
  authenticationmethods
  authorizedkeysfile .ssh/authorized_keys .ssh/authorized_keys2
  challengeresponseauthentication no
  ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
  clientalivecountmax 3
  clientaliveinterval 0
  compression delayed
  gatewayports no
  gssapiauthentication no
  gssapicleanupcredentials yes
  gssapikeyexchange no
  gssapistorecredentialsonrekey no
  gssapistrictacceptorcheck yes
  hostbasedauthentication no
  hostbasedusesnamefrompacketonly no
  hostkey /etc/ssh/ssh_host_ed25519_key
  hostkey /etc/ssh/ssh_host_rsa_key
  ignorerhosts yes
  ignoreuserknownhosts no
  ipqos lowdelay throughput
  kbdinteractiveauthentication no
  kerberosauthentication no
  kerberosorlocalpasswd yes
  kerberosticketcleanup yes
  kexalgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
  keyregenerationinterval 3600
  listenaddress 0.0.0.0:22
  listenaddress [::]:22
  logingracetime 120
  macs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com
  maxauthtries 6
  maxsessions 10
  maxstartups 10:30:100
  passwordauthentication no
  permitemptypasswords no
  permitopen any
  permitrootlogin no
  permittty yes
  permittunnel no
  permituserenvironment no
  pidfile /var/run/sshd.pid
  port 22
  printlastlog yes
  printmotd yes
  protocol 2
  pubkeyauthentication yes
  rekeylimit 0 0
  rhostsrsaauthentication no
  rsaauthentication yes
  serverkeybits 1024
  strictmodes yes
  syslogfacility AUTH
  tcpkeepalive yes
  usedns yes
  uselogin no
  usepam 1
  useprivilegeseparation yes
  versionaddendum
  x11displayoffset 10
  x11forwarding no
  x11uselocalhost yes
  xauthlocation /usr/bin/xauth
EOF
