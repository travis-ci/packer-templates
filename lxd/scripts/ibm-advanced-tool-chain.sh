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

__ibm_advanced_tool_chain_install_jammy_ppc64le() {
    __install_ibm_tool_chain 16.0 'jammy'
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
    if [[ "${os_name}" == "noble" ]]; then
      echo "No ibm_tool_chain packages for noble yet"
    else
      if [[ "${os_name}" == "jammy" ]]; then
        curl https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu/dists/jammy/615d762f.gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/advanced_tool_chain.gpg > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/advanced_tool_chain.gpg] https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu ${os_name} at${ibm_advanced_tool_chain_version}" > /etc/apt/sources.list.d/advanced_tool_chain.list
      else
        wget --quiet -O - "https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu/dists/${os_name}/6976a827.gpg.key" | apt-key add -
        echo "deb https://public.dhe.ibm.com/software/server/POWER/Linux/toolchain/at/ubuntu ${os_name} at${ibm_advanced_tool_chain_version}" > /etc/apt/sources.list.d/advanced_tool_chain.list
      fi
      apt-get update -y
      apt-get install -y \
        advance-toolchain-at${ibm_advanced_tool_chain_version}-runtime \
        advance-toolchain-at${ibm_advanced_tool_chain_version}-devel \
        advance-toolchain-at${ibm_advanced_tool_chain_version}-perf \
        advance-toolchain-at${ibm_advanced_tool_chain_version}-mcore-libs
    fi
}

main "$@"
