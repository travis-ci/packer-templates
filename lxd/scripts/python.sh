#!/usr/bin/env bash

set -o errexit
source /tmp/__common-lib.sh

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_pip
  __install_pyenv
  __install_virtualenv
  __install_default_python
  call_build_function func_name="__setup_system_site_packages"
}


__install_packages() {

  sudo apt-get update -yqq
  sudo apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    build-essential \
    python3 \
    python3-dev \
    curl \
    libbz2-dev \
    liblzma-dev \
    libncurses-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libffi-dev \
    llvm \
    make \
    tk-dev \
    wget \
    openssl \
    wget \
    zlib1g-dev

}

__install_pip() {
  dist=$(lsb_release -cs)
  if [[ "${dist}" = "xenial" ]]; then
    # Install pip for xenial
    wget https://bootstrap.pypa.io/pip/3.5/get-pip.py
    sudo python3 get-pip.py
    pip3 install --user --upgrade setuptools wheel
    rm -f get-pip.py
    id travis && chown -R travis: /home/travis/.cache/pip/
  else
    wget https://bootstrap.pypa.io/pip/3.6/get-pip.py
    sudo python3 get-pip.py
    pip3 install --user --upgrade setuptools wheel
    rm -f get-pip.py
    id travis && chown -R travis: /home/travis/.cache/pip/
  fi
  
  # Install cargo and rust
  sudo apt install rustc cargo -y

  #id travis && chown -R travis: /usr/bin/cargo/
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
  pip install --user virtualenv==20.15.1
  mkdir -p ${virtualenv_root}
  id travis && chown -R travis: ${virtualenv_root}
}

__install_default_python() {

  dist=$(lsb_release -cs)
  PYTHON_CONFIGURE_OPTS="--enable-unicode=ucs4 --with-wide-unicode --enable-shared --enable-ipv6 --with-ssl --enable-loadable-sqlite-extensions --with-computed-gotos"
  PYTHON_CFLAGS="-g -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security"
  
  if [[ "${dist}" = "xenial" ]]; then
  pyenv install 3.11.9
  else
  pyenv install 3.12.4
  fi
}

__setup_system_site_packages_xenial(){

  sudo apt-get -yqq --no-install-suggests --no-install-recommends install python python-dev python3-dev
  __setup_envirnoment "python2.7"
  __setup_envirnoment "python3.5"
}

__setup_system_site_packages_bionic(){

  sudo apt-get -yqq --no-install-suggests --no-install-recommends install python python-dev python3-dev
  __setup_envirnoment "python2.7"
  __setup_envirnoment "python3.6"
}

__setup_system_site_packages_focal(){

  sudo apt-get -yqq --no-install-suggests --no-install-recommends install python python-dev python3-dev
  __setup_envirnoment "python2.7"
  __setup_envirnoment "python3.8"
}

__setup_system_site_packages_jammy(){

  sudo apt-get -yqq --no-install-suggests --no-install-recommends install python3-dev
  sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
  sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
  __setup_envirnoment_jammy "python3.10"
}

__setup_system_site_packages() {
  #noop
  :
}

__setup_envirnoment() {

  pyname=$1
  venv_fullname="/home/travis/virtualenv/${pyname}_with_system_site_packages"
  /home/travis/.local/bin/virtualenv --system-site-packages --python=/usr/bin/${pyname} ${venv_fullname}
  ${venv_fullname}/bin/pip install wheel
  id travis && chown -R travis: ${venv_fullname}
}

__setup_envirnoment_jammy() {

  pyname=$1
  venv_fullname="/home/travis/virtualenv/${pyname}_with_system_site_packages"
  /home/travis/.local/bin/virtualenv --system-site-packages --python=/usr/bin/${pyname} ${venv_fullname}
  ${venv_fullname}/local/bin/pip install wheel
  id travis && chown -R travis: ${venv_fullname}
}

main "$@"