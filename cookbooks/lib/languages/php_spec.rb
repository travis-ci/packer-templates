# frozen_string_literal: true

include Support::Php

require 'features/php_interpreter_spec'

if os[:arch] !~ /ppc64|aarch64|arm64/
  describe 'php environment' do
    describe phpcommand('php-fpm --version') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/^PHP \d+\.\d+\.\d+.+fpm-fcgi/) }
    end

    if %w[xenial bionic focal].include?(Support.distro)
      describe phpcommand('php -m --version') do
        # Running `php -m` hangs, but adding more args doesn't (???)
        its(:stdout) { should include(*PHP_MODULES_OLDER) }
      end
    elsif %w[jammy noble].include?(Support.distro)
      describe phpcommand('php -m --version') do
        # Running `php -m` hangs, but adding more args doesn't (???)
        its(:stdout) { should include(*PHP_MODULES_NEWER) }
      end
    end

    describe file('/home/travis/.pearrc') do
      it { should_not exist }
    end
  end
end

PHP_MODULES_OLDER = <<~EOF.split("\n")
  Core
  PDO
  Phar
  SPL
  Xdebug
  bcmath
  ctype
  curl
  date
  dom
  exif
  filter
  ftp
  gd
  hash
  iconv
  json
  libxml
  mbstring
  pcre
  pdo_mysql
  pdo_sqlite
  posix
  readline
  sqlite3
  standard
  sysvsem
  sysvshm
  tidy
  xmlrpc
  xmlwriter
  xsl
  zip
  zlib
EOF

PHP_MODULES_NEWER = <<~EOF.split("\n")
  bcmath
  bz2
  calendar
  Core
  ctype
  curl
  date
  dba
  dom
  exif
  fileinfo
  filter
  ftp
  gd
  gettext
  gmp
  hash
  iconv
  imap
  intl
  json
  ldap
  libxml
  mbstring
  mysqli
  mysqlnd
  openssl
  pcntl
  pcre
  PDO
  pdo_mysql
  pdo_pgsql
  pdo_sqlite
  pgsql
  Phar
  posix
  readline
  Reflection
  session
  shmop
  SimpleXML
  soap
  sockets
  sodium
  SPL
  sqlite3
  standard
  sysvmsg
  sysvsem
  sysvshm
  tidy
  tokenizer
  xdebug
  xml
  xmlreader
  xmlwriter
  xsl
  Zend OPcache
  zip
  zlib
EOF
