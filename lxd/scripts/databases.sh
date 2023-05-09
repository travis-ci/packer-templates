#!/usr/bin/env bash
set -o errexit

source /tmp/__common-lib.sh

main() {
  export DEBIAN_FRONTEND='noninteractive'
  __install_packages
  call_build_function func_name="__couchdb_install"
  call_build_function func_name="__mongodb_install"
  call_build_function func_name="__redis"
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

__mongodb_install_xenial_ppc64le(){
  echo 'deb http://travis-ci-deb.s3.us-east-2.amazonaws.com xenial main' > /etc/apt/sources.list.d/travis-packages.list
  wget -qO - https://travis-ci-deb.s3.us-east-2.amazonaws.com/pub-key.gpg | apt-key add -
  apt-get update
  #apt-get install -y mongodb-server
}

__mongodb_install_xenial_s390x(){
  echo 'deb http://travis-ci-deb.s3.us-east-2.amazonaws.com xenial main' > /etc/apt/sources.list.d/travis-packages.list
  wget -qO - https://travis-ci-deb.s3.us-east-2.amazonaws.com/pub-key.gpg | apt-key add -
  apt-get update
  #apt-get install -y mongodb-server
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

__mongodb_install_bionic_ppc64le(){
  echo 'deb http://travis-ci-deb.s3.us-east-2.amazonaws.com bionic main' > /etc/apt/sources.list.d/travis-packages.list
  wget -qO - https://travis-ci-deb.s3.us-east-2.amazonaws.com/pub-key.gpg | apt-key add -
  apt-get update
  #apt-get install -y mongodb-server
}

__mongodb_install_focal(){
  . /etc/os-release
  curl -sL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
  echo "deb https://repo.mongodb.org/apt/ubuntu ${VERSION_CODENAME}/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
  apt-get update -yqq
  apt-get install -yqq \
    --no-install-suggests \
    --no-install-recommends \
    mongodb-org;
}

__mongodb_install_jammy(){
  arch=$(uname -m)
  # missing binary files for s390x arch
  if [[ "$arch" = "ppc64le" ]] || [[ "$arch" = "s390x" ]]; then
  echo "MongoDB not available for $arch";
  else
  wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc |  gpg --dearmor | sudo tee /usr/share/keyrings/mongodb.gpg > /dev/null
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    apt-get update -yqq
    apt-get install -yqq \
      --no-install-suggests \
      --no-install-recommends \
      mongodb-org;
  fi
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

__redis() {
  __redis_install
  __redis_setup
  systemctl stop redis-server
  systemctl disable redis-server
}

__redis_install() {
  add-apt-repository ppa:chris-lea/redis-server -y
  apt-get update -yqq
  apt install -y redis
}

__redis_setup() {
  sed -ie 's/^bind.*/bind 127.0.0.1/' /etc/redis/redis.conf
}

__redis_xenial(){
  echo "Package: redis-server
Pin: release o=travis-ci-deb.s3.us-east-2.amazonaws.com
Pin-Priority: 900" > /etc/apt/preferences.d/redis
  echo 'deb http://travis-ci-deb.s3.us-east-2.amazonaws.com xenial main' > /etc/apt/sources.list.d/travis-packages.list
  wget -qO - https://travis-ci-deb.s3.us-east-2.amazonaws.com/pub-key.gpg | apt-key add -
  apt-get update
  apt-get install -y redis-server
  __redis_setup
  systemctl stop redis-server
  systemctl disable redis-server
}

__redis_bionic(){
  echo "Package: redis-server
Pin: release o=travis-ci-deb.s3.us-east-2.amazonaws.com
Pin-Priority: 900" > /etc/apt/preferences.d/redis
  echo 'deb http://travis-ci-deb.s3.us-east-2.amazonaws.com bionic main' > /etc/apt/sources.list.d/travis-packages.list
  wget -qO - https://travis-ci-deb.s3.us-east-2.amazonaws.com/pub-key.gpg | apt-key add -
  apt-get update
  apt-get install -y redis-server
  __redis_setup
  systemctl stop redis-server
  systemctl disable redis-server
}

__redis_focal(){
  apt-get update
  apt-get install -y redis-server
  __redis_setup
  systemctl stop redis-server
  systemctl disable redis-server
}

__redis_jammy(){
  apt-get update
  apt-get install -y redis-server
  __redis_setup
  systemctl stop redis-server
  systemctl disable redis-server
}

__turn_off_all() {
  systemctl stop mysql
  systemctl disable mysql
  if systemctl is-enabled mongod &>/dev/null;then
    systemctl stop mongod
    systemctl disable mongod
  fi

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
  echo "couchdb - has no installation candidate"
}

__couchdb_install_focal(){
  echo "couchdb - has no installation candidate"
}

__couchdb_install_jammy(){
  echo "couchdb - has no installation candidate"
}

main "$@"
