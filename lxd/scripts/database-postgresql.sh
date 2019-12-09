#!/usr/bin/env bash

set -o errexit

source /tmp/__common-lib.sh

main() {

  export DEBIAN_FRONTEND='noninteractive'
  call_build_function func_name="__install_packages"
  call_build_function func_name="__setup_pgsql"
}

__install_packages() {
  apt-get update -yqq
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    postgresql postgresql-contrib postgresql-${PGSQL_VERSION}-postgis postgresql-${PGSQL_VERSION}-postgis-scripts postgresql-client libpq-dev libgeos++-dev;
}

__install_packages_bionic() {
  apt-get update -yqq
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    postgresql postgresql-contrib postgresql-${PGSQL_VERSION}-postgis-2.4 postgresql-${PGSQL_VERSION}-postgis-2.4-scripts postgresql-client libpq-dev libgeos++-dev;
}

__install_packages_xenial_ppc64le(){
  echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  apt-get update -yqq
    apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    postgresql-9.6 postgresql-contrib-9.6 postgresql-9.6-postgis-2.5 postgresql-9.6-postgis-2.5-scripts postgresql-client-9.6  libpq-dev libgeos++-dev;
}

__setup_pgsql_xenial_ppc64le(){
  (cd /tmp/ && sudo -u postgres bash -c "psql <<EOF
  \x
  DROP USER IF EXISTS travis;
  CREATE USER travis PASSWORD NULL SUPERUSER CREATEDB CREATEROLE REPLICATION INHERIT LOGIN;
  DROP USER IF EXISTS rails;
  CREATE USER rails PASSWORD NULL SUPERUSER CREATEDB CREATEROLE REPLICATION INHERIT LOGIN;
EOF")

  __turn_off_postgres_xenial_ppc64le

  #cat /tmp/__postgresql__9.6__main__postgresql.conf > /etc/postgresql/9.6/main/postgresql.conf
  #cat /tmp/__postgresql__${PGSQL_VERSION}__main__pg_hba.conf > /etc/postgresql/9.6/main/pg_hba.conf
  #cat /tmp/__postgresql__${PGSQL_VERSION}__initd-postgresql > /etc/init.d/postgresql

  #chmod 755 /etc/init.d/postgresql

  #chmod 644 /etc/postgresql/9.6/main/postgresql.conf
  #chown postgres:postgres /etc/postgresql/9.6/main/postgresql.conf

  #chmod 640 /etc/postgresql/9.6/main/pg_hba.conf
  #chown postgres:postgres /etc/postgresql/9.6/main/pg_hba.conf

  #rm /lib/systemd/system/postgresql.service
  #systemctl daemon-reload

  rm /tmp/__postgresql__9.6__main__postgresql.conf
  rm /tmp/__postgresql__${PGSQL_VERSION}__main__postgresql.conf
  rm /tmp/__postgresql__${PGSQL_VERSION}__main__pg_hba.conf
  rm /tmp/__postgresql__${PGSQL_VERSION}__initd-postgresql

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

  __turn_off_postgres

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

__turn_off_postgres_xenial_ppc64le(){
    systemctl stop postgresql@9.6-main
    systemctl disable postgresql@9.6-main
}

__turn_off_postgres(){
  systemctl stop postgresql@${PGSQL_VERSION}-main
  systemctl disable postgresql@${PGSQL_VERSION}-main
}


main "$@"
