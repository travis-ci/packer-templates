#!/usr/bin/env bash

set -o errexit
set -o xtrace

export DEBIAN_FRONTEND=noninteractive

. /etc/lsb-release
sed -i "s#MIRROR#${MIRROR}#g" /etc/apt/sources.list
sed -i "s#DISTRIB_CODENAME#${DISTRIB_CODENAME}#g" /etc/apt/sources.list
dpkg --remove-architecture i386
apt-get update
apt-get install ruby curl gnupg wget git software-properties-common python-jsonpatch md5deep openssl -y --no-install-recommends
apt-get dist-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

tee /etc/apt/apt.conf.d/10-force-yes <<EOF
APT::Get::Assume-Yes "true";
EOF

# package for travis caching
apt-get install hashdeep -y --no-install-recommends

# install snaps
apt-get install snapd fuse -y

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

# Travis sudoers
echo "travis ALL=(ALL) NOPASSWD:ALL
Defaults !authenticate
Defaults !env_reset
Defaults !mail_badpass" > /etc/sudoers.d/travis
chmod 440 /etc/sudoers.d/travis

# __setup_travis_user() {
#   if ! getent passwd travis &>/dev/null; then
#     if [[ -z "${TRAVIS_UID}" ]]; then
#       useradd -p travis -s /bin/bash -m travis -u 1000
#     else
#       useradd -p travis -s /bin/bash -m travis -u "${TRAVIS_UID}"
#       groupmod -g "${TRAVIS_UID}" travis
#       usermod -u "${TRAVIS_UID}" travis
#
#     fi
#   fi
#
#   echo travis:travis | chpasswd
#
#   # Save users having to create this directory at runtime (it's already on PATH)
#   mkdir -p /home/travis/bin
#
#   mkdir -p /opt
#   chmod 0755 /opt
#   chown -R travis:travis /home/travis /opt
# }
