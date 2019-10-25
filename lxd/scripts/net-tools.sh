#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
}

__install_packages() {
  sudo apt-get update -yqq
  sudo apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    wget \
    openssl \
    curl \
    rsync;
}

main "$@"
