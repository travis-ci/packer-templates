#!/usr/bin/env bash

set -o errexit
source <(sudo cat  "/tmp/__common-lib.sh")

main() {
  set -o xtrace
  
  export DOCKER_COMPOSE_VERSION="1.29.0"
  call_build_function func_name="__install_docker_composer"
}

__install_docker_composer() {
  sudo pip3 install --upgrade pip
  sudo pip3 install cryptography wheel setuptools
  sudo apt install rustc -y
  sudo pip3 install -IU "docker-compose==${DOCKER_COMPOSE_VERSION}"
}

main "$@"
