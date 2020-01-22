#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_pip
  __install_pyenv
  __install_virtualenv
  __install_default_python
}

__install_packages() {

  sudo apt-get update -yqq
  sudo apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    build-essential \
    python \
    python3 \
    python3-dev \
    curl \
    libbz2-dev \
    liblzma-dev \
    libncurses-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    llvm \
    make \
    tk-dev \
    wget \
    zlib1g-dev

}

__install_pip() {

  wget https://bootstrap.pypa.io/get-pip.py
  sudo python get-pip.py
  pip install --user --upgrade setuptools wheel

  # Install pip3
  sudo python3 get-pip.py

  rm -f get-pip.py
}

__install_pyenv() {

  install_dir="/opt/pyenv"
  git clone -q https://github.com/pyenv/pyenv.git ${install_dir}
  sudo ${install_dir}/plugins/python-build/install.sh
  id travis && chown -R travis: ${install_dir}

  export PATH="$PATH:${install_dir}/bin"
  export PYENV_ROOT="${install_dir}"

  #echo 'export PYENV_ROOT="${install_dir}"' >> ~/.bash_profile
  #echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
}

__install_virtualenv() {

  virtualenv_root="/home/travis/virtualenv"
  pip install --user virtualenv==15.1.0
  mkdir -p ${virtualenv_root}
  id travis && chown -R travis: ${virtualenv_root}
}

__install_default_python() {

  PYTHON_CONFIGURE_OPTS="--enable-unicode=ucs4 --with-wide-unicode --enable-shared --enable-ipv6 --enable-loadable-sqlite-extensions --with-computed-gotos"
  PYTHON_CFLAGS="-g -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security"
  pyenv install 3.6.0
}

main "$@"
