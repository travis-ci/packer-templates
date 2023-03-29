#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_lein

}

__install_lein() {
  set -o xtrace

  \curl -sSL -o ~/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
  chmod +x ~/bin/lein
  ~/bin/lein

}

main "$@"
