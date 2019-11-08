#!/usr/bin/env bash
set -o errexit

source /tmp/__common-lib.sh

main() {
  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  call_build_function func_name="__couchdb_install"
  call_build_function func_name="__mongodb_install"
  __redis_install
  __redis_setup
  __mysql_setup
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
    sqlite;

    debconf-set-selections <<< 'mysql-server mysql-server/root_password password'
    debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password'
    apt-get -y install mysql-server
}

# ___install_couchdb_bionic(){
#   apt-get install --no-install-recommends  erlang-abi-17.0 erlang-base  erlang-crypto erlang-eunit erlang-inets erlang-os-mon erlang-public-key erlang-ssl erlang-syntax-tools erlang-tools erlang-xmerl libcurl3
# http://old-releases.ubuntu.com/ubuntu/pool/universe/c/couchdb/couchdb-bin_1.6.0-0ubuntu7_arm64.deb
# http://old-releases.ubuntu.com/ubuntu/pool/universe/c/couchdb/couchdb-common_1.6.0-0ubuntu7_all.deb
# http://old-releases.ubuntu.com/ubuntu/pool/universe/c/couchdb/couchdb-bin_1.6.0-0ubuntu7_arm64.deb
#
# E: Unable to locate package zcouchdb-common
# E: Package 'erlang-base-hipe' has no installation candidate
# E: Package 'libicu55' has no installation candidate
# E: Package 'libmozjs185-1.0' has no installation candidate
#
# }

__mongodb_install() {
  . /etc/os-release
  curl -sL https://www.mongodb.org/static/pgp/server-4.0.asc | apt-key add -
  echo "deb https://repo.mongodb.org/apt/ubuntu ${VERSION_CODENAME}/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
  apt-get update -yqq
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    mongodb-org;
}

__mongodb_install_bionic(){
  . /etc/os-release
  curl -sL https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
  echo "deb https://repo.mongodb.org/apt/ubuntu ${VERSION_CODENAME}/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
  apt-get update -yqq
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    mongodb-org;
}

__mysql_setup() {

  mysql -h localhost -NBe "CREATE USER 'travis'@'%' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO 'travis'@'%'; CREATE USER 'travis'@'localhost' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO 'travis'@'localhost'; CREATE USER 'travis'@'127.0.0.1' IDENTIFIED BY ''; GRANT ALL PRIVILEGES ON *.* TO 'travis'@'127.0.0.1'"
  ## fix for cant-login-as-mysql-user-root-from-normal-user-account-in-ubuntu-16-04
  mysql -h localhost -NBe "DROP USER 'root'@'localhost'; CREATE USER 'root'@'localhost' IDENTIFIED BY ''; GRANT ALL ON *.* TO 'root'@'localhost'; FLUSH PRIVILEGES;"

  echo "[mysqld]
innodb_flush_log_at_trx_commit=0" > /etc/mysql/conf.d/innodb_flush_log_at_trx_commit.cnf
  chmod 644 /etc/mysql/conf.d/innodb_flush_log_at_trx_commit.cnf

  echo "[mysqld]
performance_schema=OFF" > /etc/mysql/conf.d/performance-schema.cnf
  chmod 644 /etc/mysql/conf.d/performance-schema.cnf

  echo "[client]
default-character-set = utf8
port = 3306
user = root
password =
socket = /var/run/mysqld/mysqld.sock

[mysql]
default-character-set = utf8" > /home/travis/.my.cnf
  chmod 640 /home/travis/.my.cnf
  chown travis: /home/travis/.my.cnf

  echo "export MYSQL_UNIX_PORT=/var/run/mysqld/mysqld.sock" > /home/travis/.bash_profile.d/travis-mysql.bash
  chmod 644 /home/travis/.bash_profile.d/travis-mysql.bash
  chown travis: /home/travis/.bash_profile.d/travis-mysql.bash
}

__redis_install() {
  add-apt-repository ppa:chris-lea/redis-server -y
  apt-get update -yqq
  apt install -y redis
}

__redis_setup() {
  sed -ie 's/^bind.*/bind 127.0.0.1/' /etc/redis/redis.conf
}

__turn_off_all() {
  systemctl stop redis-server mysql mongod
  systemctl disable redis-server mysql mongod
  if systemctl is-enabled couchd &>/dev/null;then
    systemctl stop couchd
    systemctl disable couchdb
  fi

}

__couchdb_install(){
  apt-get update -yqq
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    couchdb;
}

__couchdb_install_bionic(){
  echo "couchdb - no instaling on bionic"
}

main "$@"
