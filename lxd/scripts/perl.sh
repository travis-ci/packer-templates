#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_perlbrew

}

__install_perlbrew() {
  set -o xtrace

  \curl -L http://install.perlbrew.pl | bash
  tee /home/travis/.bash_profile.d/perlbrew.bash <<\EOF
source ~/perl5/perlbrew/etc/bashrc
EOF
}

main "$@"
