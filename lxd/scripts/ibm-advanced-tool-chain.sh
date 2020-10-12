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

__ibm_advaced_tool_chain_install_focal_ppc64el() {
    __ibm_advaced_tool_chain_focal_install
}

__ibm_advaced_tool_chain_install_focal_amd64() {
    __ibm_advaced_tool_chain_focal_install
}

__ibm_advaced_tool_chain_focal_install() {
    wget --quiet -O - https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu/dists/focal/6976a827.gpg.key | apt-key add -
    echo "deb https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu focal at20.04" > /etc/apt/sources.list.d/advanced_tool_chain.list

    apt-get -y update

    apt-get -y install advance-toolchain-at20.04-runtime \
      advance-toolchain-at20.04-devel \
      advance-toolchain-at20.04-perf \
      advance-toolchain-at20.04-mcore-libs
}

main "$@"
