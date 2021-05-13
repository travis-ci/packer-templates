#!/usr/bin/env bash
source /etc/os-release
set -o errexit

main() {
  set -o xtrace
  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_java
  __install_maven
}

__install_packages() {
  apt-get update -yqq
  apt-get install -yqq --no-install-suggests --no-install-recommends  \
  libasound2 libcups2 libfontconfig1 libxrender1 libxext6 libx11-6 \
  libnss3 libgcc1 util-linux zlib1g libstdc++6 libpcsclite1 libfreetype6 libjpeg8 liblcms2-2 libxtst6 wget;
}

__install_java(){
  . /etc/os-release
  wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
  echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ ${VERSION_CODENAME} main" | tee /etc/apt/sources.list.d/adoptopenjdk.list
  rm -rf /var/lib/apt/lists/*
  apt-get update -yqq
  apt-get -yqq --no-install-suggests --no-install-recommends install adoptopenjdk-${JAVA_VERSION}-hotspot
}

__install_maven(){
  mkdir -p /opt/mvn
  curl https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz|tar -xz --strip 1 -C /opt/mvn

  echo 'export MAVEN_HOME=/opt/mvn
  export PATH=${MAVEN_HOME}/bin:${PATH}' > /home/travis/.bash_profile.d/mvn.bash
  chmod 644 /home/travis/.bash_profile.d/mvn.bash
  chown travis: /home/travis/.bash_profile.d/mvn.bash
}

main "$@"
