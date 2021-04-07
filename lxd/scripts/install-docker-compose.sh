#!/usr/bin/env bash

set -o errexit
source <(sudo cat  "/tmp/__common-lib.sh")

main() {
  set -o xtrace
  pip install --upgrade pip
  python3 -m pip install --upgrade pip
  export DOCKER_COMPOSE_VERSION="1.29.0"
  call_build_function func_name="__install_docker_composer"
}

__install_docker_composer() {

  sudo pip3 install -IU "docker-compose==${DOCKER_COMPOSE_VERSION}"
}

main "$@"
