#!/usr/bin/env bash

set -o errexit
set -o xtrace

export DEBIAN_FRONTEND=noninteractive

# lang c packages
dist=$(lsb_release -sc)
if [[ $dist = "jammy" ]]; then
  apt-get install automake autoconf flex bison make cmake gcc g++ libsystemd-dev gcovr clang scons -y
else
  apt-get install llvm-6.0 automake autoconf flex bison make cmake gcc g++ libsystemd-dev gcovr clang scons -y
  update-alternatives --install /usr/bin/llvm-symbolizer llvm-symbolizer /usr/lib/llvm-6.0/bin/llvm-symbolizer 1
fi

source /etc/os-release
case "$VERSION_CODENAME" in
  bionic)
    apt-get install gcc-7 g++-7 -y
    ;;
esac
