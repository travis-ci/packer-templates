override['java']['default_version'] = ''
override['java']['alternate_versions'] = []

override['nodejs']['default'] = ''
override['nodejs']['versions'] = []
override['nodejs']['aliases'] = []
override['nodejs']['default_modules'] = []

override['phpenv']['prerequisite_recipes'] = []

override['phpbuild']['prerequisite_recipes'] = []

override['php']['multi']['versions'] = []
override['php']['multi']['extensions'] = []
override['php']['multi']['prerequisite_recipes'] = %w(
  bison
  phpbuild
  phpenv
)
override['php']['multi']['postrequisite_recipes'] = %w(
  composer
  phpunit
)
override['php']['multi']['binaries'] = []

override['composer']['github_oauth_token'] = '2d8490a1060eb8e8a1ae9588b14e3a039b9e01c6'

override['perlbrew']['perls'] = []
override['perlbrew']['modules'] = []
override['perlbrew']['prerequisite_packages'] = []

override['gimme']['versions'] = []
override['gimme']['default_version'] = ''

override['python']['pyenv']['pythons'] = []
override['python']['pyenv']['aliases'] = {}
override['python']['pip']['packages'] = {}
override['python']['system']['pythons'] = []

override['rvm']['rubies'] = ['2.2.3']

override['travis_rvm']['latest_minor'] = true
override['travis_rvm']['default'] = '2.2.3'
override['travis_rvm']['rubies'] = [
  { name: '2.2.3', arguments: '--binary --fuzzy' }
]
override['travis_rvm']['gems'] = %w(nokogiri)
override['travis_rvm']['multi_prerequisite_recipes'] = []
override['travis_rvm']['prerequisite_recipes'] = []
override['travis_rvm']['pkg_requirements'] = []

override['system_info']['use_bundler'] = false
override['system_info']['commands_file'] = '/var/tmp/minimal-system-info-commands.yml'

override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_build_environment']['update_hosts_atomically'] = false
override['travis_build_environment']['packages'] = %w(
  autoconf
  automake
  bash
  bison
  build-essential
  bzip2
  bzr
  ca-certificates
  ccache
  cmake
  curl
  flex
  gawk
  gzip
  imagemagick
  iptables
  lemon
  libbz2-dev
  libbz2-dev
  libc-client2007e-dev
  libcurl4-openssl-dev
  libexpat1-dev
  libffi-dev
  libfreetype6-dev
  libgdbm-dev
  libgmp3-dev
  libicu-dev
  libicu-dev
  libjpeg8-dev
  libkrb5-dev
  libldap-2.4.2
  libldap2-dev
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
  libxslt-dev
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
  sqlite3
  subversion
  unzip
  wamerican
  zip
  zlib1g-dev
)
