#!/usr/bin/env bash

set -o errexit
set -o xtrace

export PATH=/snap/bin/:$PATH

aws s3 cp ${IMAGE_NAME}.tar.gz s3://travis-lxc-images/${ARCH}/ --acl public-read
aws s3 ls s3://travis-lxc-images/${ARCH}/${IMAGE_NAME}.tar.gz && rm -f ${IMAGE_NAME}.tar.gz
