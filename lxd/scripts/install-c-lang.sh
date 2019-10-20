#!/usr/bin/env bash

set -o errexit
set -o xtrace

export DEBIAN_FRONTEND=noninteractive

# lang c packages
apt-get install llvm-6.0 automake autoconf flex bison make cmake gcc g++ libsystemd-dev gcovr clang scons -y
update-alternatives --install /usr/bin/llvm-symbolizer llvm-symbolizer /usr/lib/llvm-6.0/bin/llvm-symbolizer 1

source /etc/os-release
case "$VERSION_CODENAME" in
  bionic)
    apt-get install gcc-7 g++-7 -y
    ;;
esac
