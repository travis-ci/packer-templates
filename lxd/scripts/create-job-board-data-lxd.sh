#!/usr/bin/env bash
set -o errexit

__languages() {

  for lang in ${LANGUAGES//,/ }
  do
    echo "  language_$lang: true"
  done
}

main() {
  : "${JOB_BOARD_REGISTER_FILE:=/tmp/.job-board-register.yml}"

  local nowtime
  local languages
  nowtime=$(date -u +%Y%m%dT%H%M%SZ)
  languages=$(__languages)
  languages_list=${languages//[[:space:]][[:space:]]/,}

  cat > ${JOB_BOARD_REGISTER_FILE} <<EOF
---
stack: lxd-${ARCH}
languages:
- ${LANGUAGES}
features:
- docker
tags:
  dist: ${JOB_BOARD_IMAGE_DIST}
  os: linux
  group: stable
  packer_chef_time: "${nowtime}"
${languages}
tags_string: "dist:${JOB_BOARD_IMAGE_DIST},os:linux,packer_chef_time:${nowtime}${languages_list//[[:space:]]/}"
EOF
  echo "Job board file ${JOB_BOARD_REGISTER_FILE}"
}

main "$@"
