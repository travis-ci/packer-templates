#!/usr/bin/env bash

set -o errexit
source <(sudo cat  "/tmp/__common-lib.sh")

main() {
  set -o xtrace
  
  # issue with docker-compose version 1.29.2 - PyYAML=5.4.1 and it's cython dependency, need to downgrade either docker-compose or fight with pyyaml version
  export DOCKER_COMPOSE_VERSION="1.29.0"
  call_build_function func_name="__install_docker_composer"
}

__install_docker_composer() {
  dist=$(lsb_release -cs)
  if [[ "${dist}" = "noble" ]]; then
    sudo pip3 install --no-deps "docker-compose==${DOCKER_COMPOSE_VERSION}" --break-system-packages
  else
    sudo pip3 install pip wheel
    sudo pip3 install --upgrade pip
    sudo pip3 install cryptography setuptools
    # sudo pip3 install pyyaml~=6.0
    sudo pip3 install -U --ignore-installed pyyaml 
    sudo pip3 install --no-deps "docker-compose==${DOCKER_COMPOSE_VERSION}"
  fi
  # create an alias for docker
  cat <<'EOF' >>docker_func
  #!/usr/bin/env bash
    main() {
      if [ "$2" = "run" ]; then
          shift
          command docker run -t -v /proc/cpuinfo:/proc/cpuinfo:rw -v /proc/meminfo:/proc/meminfo:rw -v /proc/stat:/proc/stat:rw "$@"
      else
          command docker "$@"
      fi
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
