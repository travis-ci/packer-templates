#!/usr/bin/env bash

set -o errexit
source /tmp/__common-lib.sh

__install_packages() {

  apt install python-jsonpatch -y --no-install-recommends
}

__install_packages_focal() {

  apt install python3-jsonpatch -y --no-install-recommends
}

__install_packages_jammy() {

  apt install python3-jsonpatch -y --no-install-recommends
}

__install_packages_noble() {

  apt install python3-jsonpatch -y --no-install-recommends
}

__network_setup() {
  # disable cloud network init
  echo network: {config: disabled} > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
  # enable manage_etc_hosts: true
  grep -q manage_etc_hosts /etc/cloud/cloud.cfg || echo manage_etc_hosts: true | tee -a /etc/cloud/cloud.cfg
  # Limit ds
  echo datasource_list: [ NoCloud ] > /etc/cloud/cloud.cfg.d/98-disable-ds.cfg
  
  mkdir -p /etc/systemd/system/systemd-networkd.service.d
  echo "[Service]" >> /etc/systemd/system/systemd-networkd.service.d/override.conf
  echo "ReadOnlyPaths=/sys" >> /etc/systemd/system/systemd-networkd.service.d/override.conf
  systemctl daemon-reload
}

__network_setup_xenial() {
  echo "Xenial: don't override network config"
  # enable manage_etc_hosts: true
  grep -q manage_etc_hosts /etc/cloud/cloud.cfg || echo manage_etc_hosts: true | tee -a /etc/cloud/cloud.cfg
}

export DEBIAN_FRONTEND=noninteractive
# Force use of ipv4
echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4
# Add sources
. /etc/lsb-release
dist=$(lsb_release -sc)
if [[ $dist = "noble" ]]; then
  # sed -i "s#MIRROR#${MIRROR}#g" /etc/apt/sources.list.d/ubuntu.sources
  # sed -i "s#DISTRIB_CODENAME#${DISTRIB_CODENAME}#g" /etc/apt/sources.list.d/ubuntu.sources
  cat /etc/apt/sources.list.d/ubuntu.sources
else
  sed -i "s#MIRROR#${MIRROR}#g" /etc/apt/sources.list
  sed -i "s#DISTRIB_CODENAME#${DISTRIB_CODENAME}#g" /etc/apt/sources.list
  dpkg --remove-architecture i386
fi
apt update -yyq
# missing git-lfs package for xenial
if [[ $dist = "xenial" ]]; then
  apt install ruby curl gnupg wget git software-properties-common md5deep openssl fuse hashdeep snapd dnsutils -y --no-install-recommends
else
  apt install ruby curl gnupg wget git git-lfs software-properties-common md5deep openssl fuse hashdeep snapd dnsutils -y --no-install-recommends
fi
apt dist-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

call_build_function func_name="__install_packages"

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

call_build_function func_name="__network_setup"

# sudo: setrlimit(RLIMIT_CORE): Operation not permitted
echo "Set disable_coredump false" >> /etc/sudo.conf
