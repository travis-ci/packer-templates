#!/usr/bin/env bash

set -o errexit

source /tmp/__common-lib.sh

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  call_build_function func_name="__ibm_advaced_tool_chain_install"
}

__ibm_advaced_tool_chain_install() {
    echo "IBM advaced tool chain - has no installation candidate"
}

__ibm_advaced_tool_chain_install_focal_ppc64le() {
    __ibm_advaced_tool_chain_focal_install
}

__ibm_advaced_tool_chain_install_focal_amd64() {
    __ibm_advaced_tool_chain_focal_install
}

__ibm_advaced_tool_chain_install_bionic_ppc64le() {
    __ibm_advaced_tool_chain_bionic_install
}

__ibm_advaced_tool_chain_install_bionic_amd64() {
    __ibm_advaced_tool_chain_bionic_install
}


__ibm_advaced_tool_chain_focal_install() {
    wget --quiet -O - https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu/dists/focal/6976a827.gpg.key | apt-key add -
    echo "deb https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu focal at14.0" > /etc/apt/sources.list.d/advanced_tool_chain.list

    apt-get -y update

    apt-get -y install advance-toolchain-at14.0-runtime \
      advance-toolchain-at14.0-devel \
      advance-toolchain-at14.0-perf \
      advance-toolchain-at14.0-mcore-libs
}

__ibm_advaced_tool_chain_bionic_install() {
    wget --quiet -O - https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu/dists/bionic/6976a827.gpg.key | apt-key add -
    echo "deb https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu bionic at14.0" > /etc/apt/sources.list.d/advanced_tool_chain.list

    apt-get -y update

    apt-get -y install advance-toolchain-at14.0-runtime \
      advance-toolchain-at14.0-devel \
      advance-toolchain-at14.0-perf \
      advance-toolchain-at14.0-mcore-libs
}

main "$@"
