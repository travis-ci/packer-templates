#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_phpenv
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
    libreadline6-dev;
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

main "$@"
