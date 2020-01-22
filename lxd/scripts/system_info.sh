#!/usr/bin/env bash

set -o errexit

# system info gem
curl -sSL -o ./system-info-2.0.3.gem https://s3.amazonaws.com/travis-system-info/system-info-2.0.3.gem
gem install -b system-info-2.0.3.gem
rm -f ./system-info-2.0.3.gem

DEST_DIR="/usr/share/travis"
sudo mkdir -p ${DEST_DIR}
sudo chown travis: ${DEST_DIR}

system-info report --formats human,json --human-output ${DEST_DIR}/system_info --json-output ${DEST_DIR}/system_info.json
