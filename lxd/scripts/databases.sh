#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

source /tmp/__common-lib.sh

arch=$(uname -m)
. /etc/os-release

export DEBIAN_FRONTEND=noninteractive

main() {
    apt-get update -yqq
    install_mysql
    install_redis
    install_mongodb
    install_couchdb
    stop_disable_services
}

install_mysql() {
    echo "Installing MySQL..."
    debconf-set-selections <<< 'mysql-server mysql-server/root_password password '
    debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '
    apt-get install -yqq mysql-server

    mysql -h localhost -NBe "
    CREATE USER IF NOT EXISTS 'travis'@'%' IDENTIFIED BY '';
    GRANT ALL PRIVILEGES ON *.* TO 'travis'@'%';
    CREATE USER IF NOT EXISTS 'travis'@'localhost' IDENTIFIED BY '';
    GRANT ALL PRIVILEGES ON *.* TO 'travis'@'localhost';
    CREATE USER IF NOT EXISTS 'travis'@'127.0.0.1' IDENTIFIED BY '';
    GRANT ALL PRIVILEGES ON *.* TO 'travis'@'127.0.0.1';
    DROP USER IF EXISTS 'root'@'localhost';
    CREATE USER 'root'@'localhost' IDENTIFIED BY '';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';
    FLUSH PRIVILEGES;
    "

    cat > /etc/mysql/conf.d/innodb_flush_log_at_trx_commit.cnf <<'EOF'
[mysqld]
innodb_flush_log_at_trx_commit=0
EOF

    cat > /etc/mysql/conf.d/performance-schema.cnf <<'EOF'
[mysqld]
performance_schema=OFF
EOF

    mkdir -p /home/travis/.bash_profile.d
    cat > /home/travis/.my.cnf <<'EOF'
[client]
default-character-set = utf8
port = 3306
user = root
password =
socket = /var/run/mysqld/mysqld.sock

[mysql]
default-character-set = utf8
EOF

    chmod 640 /home/travis/.my.cnf
    chown travis: /home/travis/.my.cnf

    echo "export MYSQL_UNIX_PORT=/var/run/mysqld/mysqld.sock" > /home/travis/.bash_profile.d/travis-mysql.bash
    chmod 644 /home/travis/.bash_profile.d/travis-mysql.bash
    chown travis: /home/travis/.bash_profile.d/travis-mysql.bash
}

install_redis() {
    echo "Installing Redis..."
    apt-get install -yqq redis-server
    # Bind to localhost
    sed -i 's/^bind .*/bind 127.0.0.1/' /etc/redis/redis.conf
}

install_mongodb() {
    arch=$(uname -m)
    dist=$(lsb_release -sc)

    # Only proceed on ARM64
    if [[ "$arch" != "aarch64" ]]; then
        echo "Skipping MongoDB installation on $arch"
        return 0
    fi

    case "$dist" in
        focal) MONGO_VERSION="4.4" ;;
        jammy) MONGO_VERSION="6.0" ;;
        noble) MONGO_VERSION="8.0" ;;
        *)
            echo "MongoDB not supported on ${dist}"
            return 0
            ;;
    esac

    echo "Installing MongoDB $MONGO_VERSION on ARM64 $dist..."

    # Add MongoDB GPG key
    curl -fsSL "https://www.mongodb.org/static/pgp/server-${MONGO_VERSION}.asc" | \
       sudo  gpg -o /usr/share/keyrings/mongodb.gpg --dearmor

    # Add repo (arch=arm64 only)
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/mongodb.gpg] https://repo.mongodb.org/apt/ubuntu ${dist}/mongodb-org/${MONGO_VERSION} multiverse" > /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list
    apt-get update -y
    apt-get install -y \
      --no-install-suggests \
      --no-install-recommends \
      mongodb-org

      rm -f /etc/apt/sources.list.d/mongodb-org*.list*
}

install_couchdb() {
    echo "Installing CouchDB..."
    echo "CouchDB not available for Focal, Jammy and Noble. Skipping..."
}

stop_disable_services() {
    systemctl stop mysql || true
    systemctl disable mysql || true

    if systemctl list-units --type=service | grep -q mongod; then
        systemctl stop mongod || true
        systemctl disable mongod || true
    fi

    if systemctl list-units --type=service | grep -q redis-server; then
        systemctl stop redis-server || true
        systemctl disable redis-server || true
    fi

    if systemctl list-units --type=service | grep -q couchdb; then
        systemctl stop couchdb || true
        systemctl disable couchdb || true
    fi
}

main "$@"
