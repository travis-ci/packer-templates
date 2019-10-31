#!/usr/bin/env bash

set -o errexit

salt '*' cmd.run 'curl -sSL -o ${IMAGE_NAME}.tar.gz https://travis-lxc-images.s3.us-east-2.amazonaws.com/${ARCH}/${IMAGE_NAME}.tar.gz' \
  env="{IMAGE_NAME: $IMAGE_NAME, ARCH: $ARCH}"
salt '*' cmd.run '/snap/bin/lxc image import $IMAGE_NAME.tar.gz --alias=$IMAGE_NAME' \
  env="{IMAGE_NAME: $IMAGE_NAME}"
salt '*' cmd.run '/snap/bin/lxc init $IMAGE_NAME image && /snap/bin/lxc delete -f image' \
  env="{IMAGE_NAME: $IMAGE_NAME}"
