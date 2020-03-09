#!/usr/bin/env bash

set -o errexit
set -o xtrace

export PATH=/snap/bin/:$PATH

# wait for image
while ! lxc image ls | grep -q "${IMAGE_NAME}"; do
  sleep 5
  echo -n .
done

lxc image export "${IMAGE_NAME}" /home/travis/"${IMAGE_NAME}"
aws s3 cp /home/travis/"${IMAGE_NAME}".tar.gz s3://"${LXC_AWS_BUCKET}"/amd64/ --acl public-read

sha256sum /home/travis/"${IMAGE_NAME}".tar.gz | cut -f1 -d ' ' >/home/travis/"${IMAGE_NAME}"_checksum.txt
aws s3 cp /home/travis/"${IMAGE_NAME}"_checksum.txt s3://"${LXC_AWS_BUCKET}"/amd64/ --acl public-read
