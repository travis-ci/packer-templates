#!/usr/bin/env bash

set -o errexit

export DEBIAN_FRONTEND=noninteractive

. /etc/lsb-release
sed -i "s#MIRROR#${MIRROR}#g" /etc/apt/sources.list
sed -i "s#DISTRIB_CODENAME#${DISTRIB_CODENAME}#g" /etc/apt/sources.list
dpkg --remove-architecture i386
apt update -qyy
apt install ruby curl gnupg wget git software-properties-common python-jsonpatch md5deep openssl fuse hashdeep snapd -y --no-install-recommends
apt dist-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

tee /etc/apt/apt.conf.d/10-force-yes <<EOF
APT::Get::Assume-Yes "true";
EOF

source /etc/os-release

# install travis user
userdel ubuntu
useradd -p travis -s /bin/bash -m travis -u 1000

echo travis:travis | chpasswd

# Save users having to create this directory at runtime (it's already on PATH)
mkdir -p /home/travis/bin

mkdir -p /opt
chmod 0755 /opt
chown -R travis:travis /home/travis /opt

#bash_profile, bash_profile.d
mkdir /home/travis/.bash_profile.d
echo '[[ -s "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

if [[ -d "${HOME}/.bash_profile.d" ]]; then
  for f in "${HOME}/.bash_profile.d/"*.bash; do
    if [[ -s "${f}" ]]; then
      source "${f}"
    fi
  done
fi
' >> /home/travis/.bash_profile

chown -R travis:travis /home/travis/.bash_profile.d
chown -R travis:travis /home/travis/.bash_profile
chmod 640 /home/travis/.bash_profile

# Travis sudoers
tee /etc/sudoers.d/travis <<EOF
travis ALL=(ALL) NOPASSWD:ALL
Defaults !authenticate
Defaults !env_reset
Defaults !mail_badpass
EOF
chmod 440 /etc/sudoers.d/travis

# artifacts
arch=$(uname -m)
if [[ $arch = "aarch64" ]]; then
  arch="arm64"
fi
curl -sL -o /home/travis/bin/artifacts https://s3.amazonaws.com/travis-ci-gmbh/artifacts/351/351.2/build/linux/${arch}/artifacts
chmod +x /home/travis/bin/artifacts
chown travis: /home/travis/bin/artifacts
