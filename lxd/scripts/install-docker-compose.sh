#!/usr/bin/env bash

set -o errexit
source <(sudo cat  "/tmp/__common-lib.sh")

main() {
  set -o xtrace
  
  export DOCKER_COMPOSE_VERSION="1.28.6"
  call_build_function func_name="__install_docker_composer"
}

__install_docker_composer() {
  sudo pip3 install --upgrade pip
  sudo pip3 install cryptography wheel setuptools
  sudo pip3 install -IU "docker-compose==${DOCKER_COMPOSE_VERSION}"

  # create an alias for docker
  cat <<'EOF' >>docker_func
  #!/usr/bin/env bash
    main() {
    args="$@"
    docker -v /proc/cpuinfo:/proc/cpuinfo:rw -v /proc/meminfo:/proc/meminfo:rw -v /proc/stat:/proc/stat:rw node:latest bash
    docker $args;
  }
  main "$@";
EOF

  # Create an alias for docker and make it executable for non-interative shell
  sudo chmod +x docker_func && sudo mv docker_func /usr/local/bin
  shopt -s expand_aliases
  echo "shopt -s expand_aliases" >> /home/travis/.bash_profile
  echo "alias docker='docker_func'" >> /home/travis/.bash_profile
  echo "alias sudo='sudo '" >> /home/travis/.bash_profile
}

main "$@"
