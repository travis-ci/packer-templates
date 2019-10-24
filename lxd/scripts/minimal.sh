#!/usr/bin/env bash

set -o errexit
set -o xtrace

export DEBIAN_FRONTEND=noninteractive

# https://docs.travis-ci.com/user/reference/trusty/#version-control
apt-get install mercurial subversion git -y --no-install-recommends

# https://docs.travis-ci.com/user/reference/trusty/#compilers--build-toolchain
apt-get install gcc clang make autotools-dev cmake scons -y --no-install-recommends

# https://docs.travis-ci.com/user/reference/trusty/#networking-tools
apt-get install curl wget openssl rsync -y --no-install-recommends

# python for minimal image
# https://docs.travis-ci.com/user/languages/minimal-and-generic/#minimal
apt-get install python python-pip -y --no-install-recommends
