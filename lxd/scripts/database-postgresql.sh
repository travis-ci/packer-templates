#!/usr/bin/env bash

set -o errexit

main() {

  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  __setup_pgsql
  __turn_off_all
}

__install_packages() {
  # repo not have arm64 vesion
  #sudo apt-add-repository 'deb http://www.apache.org/dist/cassandra/debian 39x main'
  #sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-keys A278B781FE4B2BDA
  #wget -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -
  #echo 'deb https://debian.neo4j.org/repo stable/' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
  apt-get update -yqq
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    postgresql postgresql-contrib postgresql-${PGSQL_VERSION}-postgis postgresql-${PGSQL_VERSION}-postgis-scripts postgresql-client libpq-dev libgeos++-dev;
}


__setup_pgsql(){
  (cd /tmp/ && sudo -u postgres bash -c "psql <<EOF
  \x
  DROP USER IF EXISTS travis;
  CREATE USER travis PASSWORD NULL SUPERUSER CREATEDB CREATEROLE REPLICATION INHERIT LOGIN;
  DROP USER IF EXISTS rails;
  CREATE USER rails PASSWORD NULL SUPERUSER CREATEDB CREATEROLE REPLICATION INHERIT LOGIN;
EOF")

  cat /tmp/__postgresql__${PGSQL_VERSION}__main__postgresql.conf > /etc/postgresql/${PGSQL_VERSION}/main/postgresql.conf
  cat /tmp/__postgresql__${PGSQL_VERSION}__main__pg_hba.conf > /etc/postgresql/${PGSQL_VERSION}/main/pg_hba.conf
  cat /tmp/__postgresql__${PGSQL_VERSION}__initd-postgresql > /etc/init.d/postgresql

  chmod 755 /etc/init.d/postgresql

  chmod 644 /etc/postgresql/${PGSQL_VERSION}/main/postgresql.conf
  chown postgres:postgres /etc/postgresql/${PGSQL_VERSION}/main/postgresql.conf

  chmod 640 /etc/postgresql/${PGSQL_VERSION}/main/pg_hba.conf
  chown postgres:postgres /etc/postgresql/${PGSQL_VERSION}/main/pg_hba.conf

  rm /lib/systemd/system/postgresql.service
  systemctl daemon-reload

  rm /tmp/__postgresql__${PGSQL_VERSION}__main__postgresql.conf
  rm /tmp/__postgresql__${PGSQL_VERSION}__main__pg_hba.conf
  rm /tmp/__postgresql__${PGSQL_VERSION}__initd-postgresql
}
__turn_off_all() {
  systemctl stop postgresql
  systemctl disable postgresql
}

main "$@"
