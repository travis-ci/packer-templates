#!/usr/bin/env bash
JAVA_11_URL=https://travis-java-archives.s3.amazonaws.com/linux-aarch64-java-11-2018-09-25.tar.bz2

set -o errexit

main() {
  set -o xtrace
  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __install_java
  __setup_jvm
}

__install_packages() {
  apt-get update -yqq
  apt-get install -yqq --no-install-suggests --no-install-recommends  \
  libasound2 libcups2 libfontconfig1 libxrender1 libxext6 libx11-6 \
  libnss3 libgcc1 util-linux zlib1g libstdc++6 libpcsclite1 libfreetype6 libjpeg8 liblcms2-2 libxtst6 wget;
}

__install_java(){
  JAVA_URL="JAVA_${JAVA_VERSION}_URL"

  if [ -z ${!JAVA_URL} ];then
    echo "There is no JAVA in version ${JAVA_VERSION}"
    exit 1
  fi

  mkdir -p /usr/local/lib/java${JAVA_VERSION}
  curl -s ${!JAVA_URL} | tar xjf - -C /usr/local/lib/java${JAVA_VERSION} --strip-components 1
}

__setup_jvm(){
  echo "if [[ -d /usr/local/lib/java${JAVA_VERSION} ]]; then
  export JAVA_HOME=/usr/local/lib/java${JAVA_VERSION}
  export PATH="\$JAVA_HOME/bin:\$PATH"
fi
" > /home/travis/.bash_profile.d/travis-java.bash
  chmod 644 /home/travis/.bash_profile.d/travis-java.bash
  chown travis:travis /home/travis/.bash_profile.d/travis-java.bash
}
main "$@"
