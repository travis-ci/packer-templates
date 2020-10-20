#!/usr/bin/env bash

set -o errexit

source /tmp/__common-lib.sh

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  call_build_function func_name="__ibm_advanced_tool_chain_install"
}

__ibm_advanced_tool_chain_install() {
    echo "IBM advanced tool chain - has no installation candidate"
}

__ibm_advanced_tool_chain_install_focal_ppc64le() {
    __install_ibm_tool_chain 14.0 'focal'
}

__ibm_advanced_tool_chain_install_bionic_ppc64le() {
    __install_ibm_tool_chain 14.0 'bionic'
}

__ibm_advanced_tool_chain_install_xenial_ppc64le() {
  __install_ibm_tool_chain 12.0 'xenial'
}

__install_ibm_tool_chain() {
    local ibm_advanced_tool_chain_version="${1}"
    local os_name="${2}"
    wget --quiet -O - "https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu/dists/${os_name}/6976a827.gpg.key" | apt-key add -
    echo "deb https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu ${os_name} at${ibm_advanced_tool_chain_version}" > /etc/apt/sources.list.d/advanced_tool_chain.list

    apt-get -y update

    apt-get -y install advance-toolchain-at${ibm_advanced_tool_chain_version}-runtime \
      advance-toolchain-at${ibm_advanced_tool_chain_version}-devel \
      advance-toolchain-at${ibm_advanced_tool_chain_version}-perf \
      advance-toolchain-at${ibm_advanced_tool_chain_version}-mcore-libs
}

main "$@"
