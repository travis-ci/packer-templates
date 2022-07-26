#!/usr/bin/env bash
source /etc/os-release
set -o errexit

main() {
  set -o xtrace
  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_java
  __install_maven
  __install_ant
}

__install_packages() {
  apt-get update -yqq
  apt-get install -yqq --no-install-suggests --no-install-recommends  \
  libasound2 libcups2 libfontconfig1 libxrender1 libxext6 libx11-6 \
  libnss3 libgcc1 util-linux zlib1g libstdc++6 libpcsclite1 libfreetype6 libjpeg8 liblcms2-2 libxtst6 wget;
}

__install_java(){
  wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
  sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
  rm -rf /var/lib/apt/lists/*
  apt-get update -yqq
  apt-get -yqq --no-install-suggests --no-install-recommends install adoptopenjdk-${JAVA_VERSION}-hotspot
}

__install_maven(){
  apt-get -yqq --no-install-suggests --no-install-recommends install maven
}

__install_ant() {
  mkdir -p /opt/ant
  curl -sL https://downloads.apache.org//ant/binaries/apache-ant-1.10.11-bin.tar.gz | tar -xz --strip 1 -C /opt/ant
  echo 'export ANT_HOME=/opt/ant
  export PATH=${ANT_HOME}/bin:${PATH}' > /home/travis/.bash_profile.d/ant.bash
  chmod 644 /home/travis/.bash_profile.d/ant.bash
  chown travis: /home/travis/.bash_profile.d/ant.bash
}

main "$@"