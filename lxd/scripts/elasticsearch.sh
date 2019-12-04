#!/usr/bin/env bash
set -o errexit

source /tmp/__common-lib.sh
#ELASTICSEARCH_VERSION=7.4.2

main() {
  export DEBIAN_FRONTEND='noninteractive'
  call_build_function func_name="__elasticsearch_install"
}

__elasticsearch_get_sources(){
  echo "Getting Elasticsearch sources"
  mkdir "/usr/local/lib/elasticsearch-${ELASTICSEARCH_VERSION}"
  wget -q -O - "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz"|tar -xzf -  -C  "/usr/local/lib/elasticsearch-${ELASTICSEARCH_VERSION}/" --strip 1
  rm -rf "/usr/local/lib/elasticsearch-${ELASTICSEARCH_VERSION}/jdk"
}

__elasticsearch_install(){

  __elasticsearch_get_sources


  echo -n "Creating elasticsearch user and group"
  addgroup --quiet --system elasticsearch
  adduser --quiet \
          --system \
          --no-create-home \
          --home /nonexistent \
          --ingroup elasticsearch \
          --disabled-password \
          --shell /bin/false \
          elasticsearch

  __elasticsearch_configure_plugins

  chown elasticsearch.elasticsearch "/usr/local/lib/elasticsearch-${ELASTICSEARCH_VERSION}" -R

  cat /dev/null > /etc/default/elasticsearch
  echo "ES_HOME=/usr/local/lib/elasticsearch-${ELASTICSEARCH_VERSION}/" >> /etc/default/elasticsearch
  echo "ES_PATH_CONF=/usr/local/lib/elasticsearch-${ELASTICSEARCH_VERSION}/config" >> /etc/default/elasticsearch

  #locate Java
  JAVA_DIR=$(find /usr/lib/ -maxdepth 2 -type d -name "*jdk-11*")
  if [ ! -d "$JAVA_DIR" ];then
    echo "Can't locate JAVA 11, its needed for elasticsearch"
    exit 1
  fi

  echo "JAVA_HOME=${JAVA_DIR}" >> /etc/default/elasticsearch

  chmod 750 /etc/init.d/elasticsearch

  systemctl daemon-reload
  systemctl stop elasticsearch.service
  systemctl disable elasticsearch.service
  echo "Done installing elasticsearch "
}

__elasticsearch_configure_plugins(){
  echo "Configuring Elasticsearch plugins"
  echo "xpack.ml.enabled: false" >> "/usr/local/lib/elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml"
}

main "$@"
