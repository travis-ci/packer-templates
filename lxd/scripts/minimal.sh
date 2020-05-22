#!/usr/bin/env bash

set -o errexit
set -o xtrace
source /tmp/__common-lib.sh

__install_python() {

  apt install python python-pip -y --no-install-recommends
}

__install_python_focal() {

  apt install python python3-pip -y --no-install-recommends
}

export DEBIAN_FRONTEND=noninteractive

# https://docs.travis-ci.com/user/reference/trusty/#version-control
apt-get install mercurial subversion git -y --no-install-recommends

# https://docs.travis-ci.com/user/reference/trusty/#compilers--build-toolchain
apt-get install gcc clang make autotools-dev cmake scons ccache -y --no-install-recommends

# https://docs.travis-ci.com/user/reference/trusty/#networking-tools
apt-get install curl wget openssl libssl-dev rsync -y --no-install-recommends

# python for minimal image
# https://docs.travis-ci.com/user/languages/minimal-and-generic/#minimal
call_build_function func_name="__install_python"

# for php compile
#apt-get install libxml2-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libxpm-dev libmysqlclient-dev libpq-dev libicu-dev libfreetype6-dev libldap2-dev libxslt-dev libssl-dev libldb-dev -y --no-install-recommends
