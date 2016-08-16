include Support::Php

require 'features/php_interpreter_spec'

describe 'php environment' do
  describe phpcommand('php-fpm --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^PHP \d+\.\d+\.\d+.+fpm-fcgi/) }
  end

  describe phpcommand('php -m') do
    its(:stdout) { should include(*PHP_MODULES) }
  end
end

PHP_MODULES = <<EOF.split("\n")
Core
PDO
Phar
Reflection
SPL
SimpleXML
Zend OPcache
bcmath
ctype
curl
date
dom
ereg
exif
fileinfo
filter
ftp
gd
hash
iconv
json
libxml
mbstring
mcrypt
mysql
mysqli
mysqlnd
openssl
pcntl
pcre
pdo_mysql
pdo_sqlite
posix
readline
session
shmop
soap
sockets
sqlite3
standard
sysvsem
sysvshm
tidy
tokenizer
xdebug
xml
xmlreader
xmlrpc
xmlwriter
xsl
zip
zlib
EOF
