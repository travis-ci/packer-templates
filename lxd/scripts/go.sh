#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

main() {
  set -o xtrace
  __install_go
}

__install_go() {
  echo "Installing latest Go with Snap"
  sudo systemctl restart snapd
  sudo snap install go --classic
  go version
}

main "$@"
