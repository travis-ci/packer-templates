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
  # wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
  # sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
  wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /usr/share/keyrings/adoptium.asc
  echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
  #curl https://download.bell-sw.com/pki/GPG-KEY-bellsoft | gpg --dearmor | sudo tee /usr/share/keyrings/bellsoft.gpg > /dev/null
  #echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/bellsoft.gpg] https://apt.bell-sw.com/ stable main" | sudo tee /etc/apt/sources.list.d/bellsoft.list
  rm -rf /var/lib/apt/lists/*
  apt-get update -yqq
  #adoptopenjdk-${JAVA_VERSION}-hotspot
  apt-get -yqq --no-install-suggests --no-install-recommends install temurin-${JAVA_VERSION}-jdk
}

__install_maven(){
  apt-get -yqq --no-install-suggests --no-install-recommends install maven
}

__install_ant() {
  mkdir -p /opt/ant
  curl -sL https://downloads.apache.org/ant/binaries/apache-ant-1.10.12-bin.tar.gz | tar -xz --strip 1 -C /opt/ant
  echo 'export ANT_HOME=/opt/ant
  export PATH=${ANT_HOME}/bin:${PATH}' > /home/travis/.bash_profile.d/ant.bash
  chmod 644 /home/travis/.bash_profile.d/ant.bash
  chown travis: /home/travis/.bash_profile.d/ant.bash
}

__install_ant() {
  mkdir -p /opt/ant
  curl -sL https://downloads.apache.org//ant/binaries/apache-ant-1.10.12-bin.tar.gz | tar -xz --strip 1 -C /opt/ant
  echo 'export ANT_HOME=/opt/ant
  export PATH=${ANT_HOME}/bin:${PATH}' > /home/travis/.bash_profile.d/ant.bash
  chmod 644 /home/travis/.bash_profile.d/ant.bash
  chown travis: /home/travis/.bash_profile.d/ant.bash
}

main "$@"
