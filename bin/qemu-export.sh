#!/usr/bin/env bash

set -o errexit
set -o xtrace

ls -lah /home/travis/images

gzip -k /home/travis/images/"${IMAGE_NAME}"

ls -lah /home/travis/images

aws s3 cp /home/travis/images/"${IMAGE_NAME}".gz s3://travis-qemu-images/amd64/ci-ubuntu-2004/ --acl public-read