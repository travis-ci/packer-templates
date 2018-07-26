# frozen_string_literal: true

include Support::Php

require 'features/php_interpreter_spec'

if os[:arch] !~ /ppc64/
  describe 'php environment' do
    describe phpcommand('php-fpm --version') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/^PHP \d+\.\d+\.\d+.+fpm-fcgi/) }
    end

    describe phpcommand('php -m --version') do
      # Running `php -m` hangs, but adding more args doesn't (???)
      its(:stdout) { should include(*PHP_MODULES) }
    end

    describe file('/home/travis/.pearrc') do
      it { should_not exist }
    end
  end
end

PHP_MODULES = <<~EOF.split("\n")
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
