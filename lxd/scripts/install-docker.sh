#!/usr/bin/env bash

set -o errexit
set -o xtrace

printf "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d
chmod +x /usr/sbin/policy-rc.d
apt-get install -y docker.io pigz --no-install-recommends
rm -f /usr/sbin/policy-rc.d
mkdir -p /etc/docker
if [[ $(arch) == "ppc64le" ]]
then
  #Update docker mtu to 1460
  echo '{"mtu": 1460}' > /tmp/daemon.json
  sudo cp -f /tmp/daemon.json /etc/docker/daemon.json
fi
# add travis to docker group
id travis && usermod -aG docker travis
