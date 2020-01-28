#!/usr/bin/env bash

set -o errexit
set -o xtrace

export PATH=/snap/bin/:$PATH

# wait for image
while ! $(lxc image ls | grep -q "${IMAGE_NAME}") ; do sleep 5; echo -e . ; done

lxc image export ${IMAGE_NAME} /home/travis/${IMAGE_NAME}

mkdir -p ~/.aws
tee ~/.aws/config <<EOF
[default]
EOF
tee ~/.aws/credentials <<EOF
[default]
aws_access_key_id = ${LXC_AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${LXC_AWS_SECRET_ACCESS_KEY}
EOF
aws s3 cp /home/travis/${IMAGE_NAME}.tar.gz s3://${LXC_AWS_BUCKET}/amd64/
