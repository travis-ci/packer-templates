#!/usr/bin/env bash

set -o errexit

source <(sudo cat  "/tmp/__common-lib.sh")

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_phpenv
  call_build_function func_name="__install_default_php"
  call_build_function func_name="__install_php"
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

__install_default_php_bionic_ppc64le(){
  local PHP_VERSION=8.1.7

  . /etc/os-release
  archive_url="https://travis-php-archives.s3.amazonaws.com/binaries/${ID}/${VERSION_ID}/$(uname -m)/php-${PHP_VERSION}.tar.bz2"
  curl -s -o archive.tar.bz2 $archive_url && tar xjf archive.tar.bz2 --directory /
  phpenv global ${PHP_VERSION}
}

__install_default_php_focal(){
  local PHP_VERSION=7.4

  . /etc/os-release
  archive_url="https://storage.googleapis.com/travis-ci-language-archives/php/binaries/${ID}/${VERSION_ID}/$(uname -m)/php-${PHP_VERSION}.tar.bz2"
  curl -s -o archive.tar.bz2 $archive_url && tar xjf archive.tar.bz2 --directory /
  phpenv global ${PHP_VERSION}

}

__install_default_php_jammy(){
  local PHP_VERSION=8.2

  . /etc/os-release
  archive_url="https://storage.googleapis.com/travis-ci-language-archives/php/binaries/${ID}/${VERSION_ID}/$(uname -m)/php-${PHP_VERSION}.tar.bz2"
  curl -s -o archive.tar.bz2 $archive_url && tar xf archive.tar.bz2 --directory /
  phpenv global ${PHP_VERSION}

}

__install_default_php_noble(){
  local PHP_VERSION=8.2

  . /etc/os-release
  archive_url="https://storage.googleapis.com/travis-ci-language-archives/php/binaries/${ID}/${VERSION_ID}/$(uname -m)/php-${PHP_VERSION}.tar.bz2"
  curl -s -o archive.tar.bz2 $archive_url && tar xf archive.tar.bz2 --directory /
  phpenv global ${PHP_VERSION}

}

__install_php(){

  . /etc/os-release
  for PHP_VERSION in 7.2 7.4
  do
    archive_url="https://storage.googleapis.com/travis-ci-language-archives/php/binaries/${ID}/${VERSION_ID}/$(uname -m)/php-${PHP_VERSION}.tar.bz2"
    curl -s -o archive.tar.bz2 $archive_url && tar xjf archive.tar.bz2 --directory /
  done

}

__install_php_focal(){
  echo "PHP - only 7.4 is supported"
}

__install_php_jammy(){
  echo "PHP - only 8.2 is supported"
}

__install_php_noble(){
  echo "PHP - only 8.2 is supported"
}

main "$@"
