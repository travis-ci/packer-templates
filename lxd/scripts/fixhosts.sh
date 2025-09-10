#!/usr/bin/env bash

set -o errexit

cat <<'EOF' >/root/fixhosts.sh
#!/usr/bin/env bash

sed -i '/^127/d' /etc/hosts

echo 127.0.1.1 $HOSTNAME >> /etc/hosts
echo 127.0.0.1 localhost >> /etc/hosts

exit
EOF

chmod +x /root/fixhosts.sh

cat <<EOF >/etc/systemd/system/fixhosts.service
[Unit]
Description=fixhosts
After=network.target

[Service]
Type=simple
ExecStart=/root/fixhosts.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl enable -q fixhosts.service

exit