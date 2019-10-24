#!/usr/bin/env bash

set -o errexit
set -o xtrace

export PATH=/snap/bin/:$PATH

# wait for image
while ! $(lxc image ls | grep -q "${IMAGE_NAME}") ; do sleep 5; echo -e . ; done

lxc image export ${IMAGE_NAME} ${IMAGE_NAME} && lxc image delete "${IMAGE_NAME}"

# cleanup
# lxc image ls | grep "${IMAGE_NAME}" | awk '{print $2}' | xargs lxc image delete
