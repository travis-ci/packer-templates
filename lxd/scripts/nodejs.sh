#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
}

__install_packages() {
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
  nvm install 8.12.0
}
main "$@"
