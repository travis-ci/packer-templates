#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  # __install_gimme
  __install_go
}

# __install_gimme() {

#   mkdir -p $HOME/bin
#   curl -sL -o $HOME/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
#   chmod +x $HOME/bin/gimme
#   sudo chown -R travis: /tmp/__common-lib.sh
# }

__install_go() {
  arch=$(uname -m)
  wget https://go.dev/dl/go1.21.1.linux-$arch.tar.gz
  sudo tar -C /usr/local -xzf go1.21.1.linux-$arch.tar.gz
  echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
  export PATH=\$PATH:/usr/local/go/bin
}

main "$@"
