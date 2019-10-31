#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_erlang

}

__install_erlang() {
  set -o xtrace

  \curl -sSL -o ~/bin/kerl https://raw.githubusercontent.com/kerl/kerl/master/kerl
  chmod +x ~/bin/kerl
}

main "$@"
