#!/usr/bin/env bash

set -o errexit

source /tmp/__common-lib.sh

main() {
  export DEBIAN_FRONTEND='noninteractive'
  call_build_function func_name="__install_packages"
  call_build_function func_name="__setup_pgsql"
  __clear_cfg_files
  __link_ramfs
}

__install_packages_focal() {
  echo "Installing packages for Focal"
  echo "deb http://apt-archive.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  apt-get update -yqq
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    postgresql-12 postgresql-contrib-12 postgresql-${PGSQL_VERSION}-postgis-3 postgresql-${PGSQL_VERSION}-postgis-3-scripts postgresql-client-12 libpq-dev libgeos++-dev
}

__install_packages_jammy() {
  echo "Installing packages for Jammy"
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo gpg -o /usr/share/keyrings/pgdg.gpg --dearmor
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  apt-get update -y
  apt-get install -y \
    --no-install-suggests \
    --no-install-recommends \
    postgresql-14 postgresql-contrib-14 postgresql-${PGSQL_VERSION}-postgis-3 postgresql-${PGSQL_VERSION}-postgis-3-scripts postgresql-client-14 libpq-dev libgeos++-dev
}

__install_packages_noble() {
  echo "Installing packages for Noble"
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo gpg -o /usr/share/keyrings/pgdg.gpg --dearmor
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt/ noble-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  apt-get update -y
  apt-get install -y \
    --no-install-suggests \
    --no-install-recommends \
    postgresql-16 postgresql-contrib-16 postgresql-${PGSQL_VERSION}-postgis-3 postgresql-${PGSQL_VERSION}-postgis-3-scripts postgresql-client-16 libpq-dev libgeos++-dev
}

__setup_pgsql() {
  (cd /tmp/ && sudo -u postgres bash -c "psql <<EOF
  \x
  DROP USER IF EXISTS travis;
  CREATE USER travis PASSWORD NULL SUPERUSER CREATEDB CREATEROLE REPLICATION INHERIT LOGIN;
  DROP USER IF EXISTS rails;
  CREATE USER rails PASSWORD NULL SUPERUSER CREATEDB CREATEROLE REPLICATION INHERIT LOGIN;
EOF")

  cat /tmp/__postgresql__${PGSQL_VERSION}__main__postgresql.conf > /etc/postgresql/${PGSQL_VERSION}/main/postgresql.conf
  cat /tmp/__postgresql__${PGSQL_VERSION}__main__pg_hba.conf > /etc/postgresql/${PGSQL_VERSION}/main/pg_hba.conf

  cat >/etc/systemd/system/postgresql.service <<EOF
[Unit]
Description=PostgreSQL RDBMS
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/systemctl start postgresql@${PGSQL_VERSION}-main.service
ExecStop=/bin/systemctl stop postgresql@${PGSQL_VERSION}-main.service
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable postgresql.service
  systemctl enable postgresql@${PGSQL_VERSION}-main.service
  systemctl start postgresql@${PGSQL_VERSION}-main.service

  chmod 644 /etc/postgresql/${PGSQL_VERSION}/main/postgresql.conf
  chown postgres:postgres /etc/postgresql/${PGSQL_VERSION}/main/postgresql.conf

  chmod 640 /etc/postgresql/${PGSQL_VERSION}/main/pg_hba.conf
  chown postgres:postgres /etc/postgresql/${PGSQL_VERSION}/main/pg_hba.conf
}



__turn_off_postgres() {
  systemctl stop postgresql@${PGSQL_VERSION}-main
  systemctl disable postgresql@${PGSQL_VERSION}-main
}

__clear_cfg_files() {
  rm /tmp/__postgresql__${PGSQL_VERSION}__main__postgresql.conf
  rm /tmp/__postgresql__${PGSQL_VERSION}__main__pg_hba.conf
  rm /tmp/__postgresql__${PGSQL_VERSION}__initd-postgresql
}

__link_ramfs() {
  ln -sf /dev/shm /var/ramfs
}

main "$@"
