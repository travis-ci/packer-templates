#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  __install_gimme
}

__install_gimme() {

  mkdir -p $HOME/bin
  curl -sL -o $HOME/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
  chmod +x $HOME/bin/gimme
}

main "$@"
