#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

main() {
  set -o xtrace
  export DEBIAN_FRONTEND='noninteractive'

  apt-get update -yqq
  __install_packages
}

__install_packages() {
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    unzip \
    apt-transport-https
}

main "$@"
