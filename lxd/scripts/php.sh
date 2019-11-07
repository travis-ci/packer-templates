#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_phpenv
  __install_default_php
}

__install_packages() {
  sudo apt-get update -yqq
  sudo apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    libbison-dev \
    libfreetype6-dev \
    libreadline6-dev \
    libtidy-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng-dev \
    libxpm-dev \
    libmysqlclient-dev \
    libpq-dev \
    libicu-dev \
    libldap2-dev \
    libxslt-dev \
    libssl-dev \
    libldb-dev \
    libc-client-dev \
    libkrb5-dev \
    libsasl2-dev \
    libmcrypt-dev \
    expect;
}


__install_phpenv(){
  if ! command -v phpenv; then
    export PHPENV_ROOT="$HOME/.phpenv"
    curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash

    if [ -d "${PHPENV_ROOT}" ]; then
      export PATH="${PHPENV_ROOT}/bin:${PATH}"
      eval "$(phpenv init -)"

      echo '#!/usr/bin/env bash

export PATH="$PATH:/home/travis/.phpenv/bin"
if command -v phpenv >/dev/null ; then
  eval "$(phpenv init -)"
  phpenv rehash 2>/dev/null
fi
' > /home/travis/.bash_profile.d/phpenv.bash

      chmod 644 /home/travis/.bash_profile.d/phpenv.bash
      sudo chown travis:travis /home/travis/.bash_profile.d/phpenv.bash
    else
      echo "Error installing phpenv"
      exit 1
    fi
  fi
}

__install_default_php(){
  local PHP_VERSION=7.3
  
  . /etc/os-release
  archive_url="https://storage.googleapis.com/travis-ci-language-archives/php/binaries/${ID}/${VERSION_ID}/$(uname -m)/php-${PHP_VERSION}.tar.bz2"
  curl -s -o archive.tar.bz2 $archive_url && tar xjf archive.tar.bz2 --directory /
  phpenv global ${PHP_VERSION}

}

main "$@"
