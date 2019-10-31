#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_phpenv

}

__install_packages() {

  sudo apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    expect \
    libzip-dev \
    libxml2-dev \
    libjpeg-dev \
    libpng-dev \
    libbison-dev \
    libfreetype6-dev \
    libreadline6-dev \
    libc-client-dev \
    libkrb5-dev \
    libldb-dev \
    libldap2-dev

}

__install_phpenv() {

  \curl -sSL http://git.io/phpenv-installer | bash
  tee /home/travis/.bash_profile.d/phpenv.bash <<\EOF
export PHPENV_ROOT="/home/travis/.phpenv"
if [ -d "${PHPENV_ROOT}" ]; then
  export PATH="${PHPENV_ROOT}/bin:${PATH}"
  eval "$(phpenv init -)"
fi
EOF

}

main "$@"
