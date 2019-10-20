#!/usr/bin/env bash

set -o errexit
set -o xtrace

main() {
  : "${IMAGE_METADATA_TARBALL:=/tmp/image-metadata.tar.bz2}"
  : "${PACKER_ENV_DIR:=/tmp/.packer-env}"
  : "${JOB_BOARD_REGISTER_FILE:=/tmp/.job-board-register.yml}"
  : "${NODE_ATTRIBUTES_YML:=/tmp/.node-attributes.yml}"
  : "${RSPEC_JSON_DIR:=/home/travis}"
  : "${SYSTEM_INFO_JSON:=/usr/share/travis/system_info.json}"
  : "${DPKG_MANIFEST_JSON:=/tmp/.dpkg-manifest.json}"
  : "${BIN_LIB_CHECKSUMS:=/tmp/.bin-lib.SHA256SUMS}"

  cd "${TMPDIR:-/var/tmp}"
  local dest
  dest="${IMAGE_METADATA_TARBALL##*/}"
  dest="${dest%%.tar.bz2}"
  mkdir -p "${dest}/env"

  echo "lxd" > "${dest}/env/PACKER_BUILDER_TYPE"
  echo ${ARCH} > "${dest}/env/ARCH"

  # find "${RSPEC_JSON_DIR}" \
  #   -maxdepth 1 \
  #   -name '.*_rspec.json' |
  #   while read -r rspec_json; do
  #     cp -v "${rspec_json}" "${dest}/${rspec_json##*/.}"
  #   done

  #cp -vR "${PACKER_ENV_DIR}/"* "${dest}/env/"
  if [ -f ${JOB_BOARD_REGISTER_FILE} ]; then
    cp -v ${JOB_BOARD_REGISTER_FILE} "${dest}/job-board-register.yml"
  fi
  # if [ -f "${SYSTEM_INFO_JSON}" ]; then
  #   cp -v "${SYSTEM_INFO_JSON}" "${dest}/system_info.json"
  # fi
  #
  # if [ -f "${NODE_ATTRIBUTES_YML}" ]; then
  #   cp -v "${NODE_ATTRIBUTES_YML}" "${dest}/node-attributes.yml"
  # fi
  #
  # if [ -f "${DPKG_MANIFEST_JSON}" ]; then
  #   cp -v "${DPKG_MANIFEST_JSON}" "${dest}/dpkg-manifest.json"
  # fi
  #
  # if [ -f "${BIN_LIB_CHECKSUMS}" ]; then
  #   cp -v "${BIN_LIB_CHECKSUMS}" "${dest}/bin-lib.SHA256SUMS"
  # fi

  tar -cjvf "${IMAGE_METADATA_TARBALL}" "${dest}"
}

main "$@"
