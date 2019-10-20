#!/usr/bin/env bash

set -o errexit
set -o xtrace

export PATH=/snap/bin/:$PATH

lxc image export ${IMAGE_NAME} ${IMAGE_NAME} && lxc image delete "${IMAGE_NAME}"

# cleanup
# lxc image ls | grep "${IMAGE_NAME}" | awk '{print $2}' | xargs lxc image delete
