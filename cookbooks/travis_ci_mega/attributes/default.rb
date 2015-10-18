default['travis_ci_mega']['prerequisite_packages'] = %w(
  cron
  curl
  git
  sudo
  wget
)

override['travis_phpenv']['prerequisite_recipes'] = []

override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_php']['multi']['versions'] = []
override['travis_php']['multi']['extensions'] = []
override['travis_php']['multi']['prerequisite_recipes'] = %w(
  bison
  travis_phpbuild
  travis_phpenv
)
override['travis_php']['multi']['postrequisite_recipes'] = %w(
  composer
  phpunit
)
override['travis_php']['multi']['binaries'] = []

override['composer']['github_oauth_token'] = \
  '2d8490a1060eb8e8a1ae9588b14e3a039b9e01c6'

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

override['rvm']['group_users'] = %w(travis)
override['rvm']['install_rubies'] = false
override['rvm']['rubies'] = []
override['rvm']['rvmrc']['rvm_remote_server_url3'] = \
  'https://s3.amazonaws.com/travis-rubies/binaries'
override['rvm']['rvmrc']['rvm_remote_server_type3'] = 'rubies'
override['rvm']['rvmrc']['rvm_remote_server_verify_downloads3'] = '1'
override['rvm']['user_rubies'] = []
override['rvm']['user_install_rubies'] = false

rubies = [
  { name: 'jruby-9.0.1.0' },
  { name: '1.9.3-p551', arguments: '--binary --fuzzy' },
  { name: '2.0.0-p647', arguments: '--binary --fuzzy' },
  { name: '2.1.7', arguments: '--binary --fuzzy' },
  { name: '2.2.3', arguments: '--binary --fuzzy' }
]

ruby_names = rubies.map { |r| r.fetch(:name) }
mri_names = ruby_names.reject { |n| n =~ /jruby/ }

def ruby_alias(full_name)
  nodash = full_name.split('-').first
  return nodash unless nodash.include?('.')
  nodash[0, 3]
end

override['travis_rvm']['latest_minor'] = true
override['travis_rvm']['default'] = mri_names.max
override['travis_rvm']['rubies'] = rubies
override['travis_rvm']['gems'] = %w(bundler nokogiri rake)
ruby_names.each do |full_name|
  override['travis_rvm']['aliases'][ruby_alias(full_name)] = full_name
end

gimme_versions = %w(
  1.0.3
  1.1.2
  1.2.2
  1.3.3
  1.4.2
  1.5.1
)

override['gimme']['versions'] = gimme_versions
override['gimme']['default_version'] = gimme_versions.max

override['java']['jdk_version'] = '8'
override['java']['install_flavor'] = 'oracle'
override['java']['oracle']['accept_oracle_download_terms'] = true
override['java']['oracle']['jce']['enabled'] = true

override['travis_java']['default_version'] = 'oraclejdk8'
override['travis_java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  openjdk8
  oraclejdk7
)

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

node_versions = %w(
  0.6.21
  0.8.28
  0.10.40
  0.11.16
  0.12.7
  4.1.2
)

override['nodejs']['versions'] = node_versions
override['nodejs']['aliases']['0.10'] = '0.1'
override['nodejs']['aliases']['0.11.16'] = 'node-unstable'
override['nodejs']['default'] = node_versions.max

pythons = %w(
  2.6.9
  2.7.10
  3.2.6
  3.3.6
  3.4.3
  3.5.0
  pypy-2.6.1
  pypy3-2.4.0
)

# Reorder pythons so that default python2 and python3 come first
# as this affects the ordering in $PATH.
%w(3 2).each do |pyver|
  pythons.select { |p| p =~ /^#{pyver}/ }.max.tap do |py|
    pythons.unshift(pythons.delete(py))
  end
end

def python_aliases(full_name)
  nodash = full_name.split('-').first
  return [nodash] unless nodash.include?('.')
  [nodash[0, 3]]
end

override['travis_python']['pyenv']['pythons'] = pythons
pythons.each do |full_name|
  override['travis_python']['pyenv']['aliases'][full_name] = \
    python_aliases(full_name)
end

override['rabbitmq']['enabled_plugins'] = %w(rabbitmq_management)

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_build_environment']['packages'] = %w(
  apt-transport-https
  autoconf
  automake
  bash
  bison
  bsdmainutils
  build-essential
  bzip2
  bzr
  ca-certificates
  ccache
  cron
  curl
  flex
  gawk
  git
  gzip
  imagemagick
  iptables
  lemon
  libbz2-dev
  libc-client2007e-dev
  libcurl4-openssl-dev
  libexpat1-dev
  libffi-dev
  libfreetype6-dev
  libgdbm-dev
  libgmp3-dev
  libicu-dev
  libjpeg8-dev
  libkrb5-dev
  libldap-2.4.2
  libldap2-dev
  libltdl-dev
  libmagickwand-dev
  libmcrypt-dev
  libmhash-dev
  libmysqlclient-dev
  libncurses5-dev
  libncursesw5-dev
  libossp-uuid-dev
  libpng12-dev
  libpq-dev
  libqt4-dev
  libreadline-dev
  libreadline6
  libsasl2-dev
  libsqlite3-dev
  libssl-dev
  libssl0.9.8
  libt1-dev
  libtidy-dev
  libtool
  libxml2-dev
  libxslt1-dev
  libyaml-0-2
  libyaml-dev
  lsof
  md5deep
  mercurial
  mingw32
  mysql-client
  netcat-openbsd
  openssl
  perl
  pkg-config
  postgresql-client
  python
  qt4-qmake
  ragel
  re2c
  rsync
  ruby-mysql2
  ruby2.0
  software-properties-common
  sqlite3
  subversion
  sudo
  unzip
  vim-tiny
  wamerican
  wget
  zip
  zlib1g-dev
)

override['travis_packer_templates']['job_board']['languages'] = %w(
  c
  cpp
  clojure
  go
  groovy
  java
  node_js
  python
  ruby
  rust
  scala
)
override['travis_packer_templates']['job_board']['edge'] = true
