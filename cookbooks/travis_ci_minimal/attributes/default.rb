override['travis_java']['default_version'] = ''
override['travis_java']['alternate_versions'] = []

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
  { name: '1.9.3-p551', arguments: '--binary --fuzzy' },
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
override['travis_rvm']['multi_prerequisite_recipes'] = []
override['travis_rvm']['prerequisite_recipes'] = []
override['travis_rvm']['pkg_requirements'] = []

override['gimme']['versions'] = []
override['gimme']['default_version'] = ''

override['travis_python']['pyenv']['pythons'] = []
override['travis_python']['pyenv']['aliases'] = {}
override['travis_python']['pip']['packages'] = {}
override['travis_python']['system']['pythons'] = []

override['nodejs']['default'] = ''
override['nodejs']['versions'] = []
override['nodejs']['aliases'] = {}
override['nodejs']['default_modules'] = []

override['system_info']['use_bundler'] = false
override['system_info']['commands_file'] = \
  '/var/tmp/minimal-system-info-commands.yml'

override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_build_environment']['update_hostname'] = false
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
  unzip
  wamerican
  zip
  zlib1g-dev
)

override['travis_packer_templates']['job_board']['languages'] = %w(generic)
override['travis_packer_templates']['job_board']['edge'] = true
