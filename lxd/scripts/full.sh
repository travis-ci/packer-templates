#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages

}

__install_packages() {

  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    unzip

}

main "$@"
