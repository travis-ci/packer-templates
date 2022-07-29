# frozen_string_literal: true

default['travis_ci_opal']['prerequisite_packages'] = %w[
  cron
  curl
  git
  sudo
  wget
]

override['travis_system_info']['commands_file'] = \
  '/var/tmp/opal-system-info-commands.yml'

override['travis_perlbrew']['perls'] = [
  { name: '5.28', version: 'perl-5.28.2' },
  { name: '5.28-extras', version: 'perl-5.28.2',
    arguments: '-Duseshrplib -Duseithreads', alias: '5.28-shrplib' },
  { name: '5.24', version: 'perl-5.24.0' },
  { name: '5.24-extras', version: 'perl-5.24.0',
    arguments: '-Duseshrplib -Duseithreads', alias: '5.24-shrplib' }
]
override['travis_perlbrew']['modules'] = %w[
  Dist::Zilla
  Dist::Zilla::Plugin::Bootstrap::lib
  ExtUtils::MakeMaker
  LWP
  Module::Install
  Moose
  Test::Exception
  Test::Most
  Test::Pod
  Test::Pod::Coverage
]
override['travis_perlbrew']['prerequisite_packages'] = []

gimme_versions = %w[
  1.11.1
]

override['travis_build_environment']['gimme']['versions'] = gimme_versions
override['travis_build_environment']['gimme']['default_version'] = gimme_versions.max

ghc_versions = %w[
  7.10.3
  8.0.2
]
cabal_versions = %w[
  1.22
  1.24
]
override['travis_build_environment']['haskell_ghc_versions'] = ghc_versions
override['travis_build_environment']['haskell_cabal_versions'] = cabal_versions
override['travis_build_environment']['haskell_default_ghc'] = ghc_versions.max
override['travis_build_environment']['haskell_default_cabal'] = cabal_versions.max

if node['kernel']['machine'] == 'ppc64le'
  override['travis_java']['default_version'] = 'openjdk8'
  override['travis_java']['alternate_versions'] = %w[openjdk7]
else
  override['travis_jdk']['versions'] = %w[
    openjdk10
    openjdk11
  ]
  override['travis_jdk']['default'] = 'openjdk11'
end

override['travis_build_environment']['nodejs_versions'] = %w[
  11.0.0
  8.12.0
]
override['travis_build_environment']['nodejs_default'] = '8.12.0'

pythons = %w[
  2.7.15
  3.6.7
  3.7.1
]

# Reorder pythons so that default python2 and python3 come first
# as this affects the ordering in $PATH.
%w[3 2].each do |pyver|
  pythons.select { |p| p =~ /^#{pyver}/ }.max.tap do |py|
    pythons.unshift(pythons.delete(py))
  end
end

def python_aliases(full_name)
  nodash = full_name.split('-').first
  return [nodash] unless nodash.include?('.')

  [nodash[0, 3]]
end

override['travis_build_environment']['pythons'] = pythons
pythons.each do |full_name|
  override['travis_build_environment']['python_aliases'][full_name] = \
    python_aliases(full_name)
end

rubies = %w[
  2.4.5
  2.5.3
]

override['travis_build_environment']['default_ruby'] = rubies.reject { |n| n =~ /jruby/ }.max
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  25.0.2
]
elixirs = %w[
  1.7.4
]

override['travis_build_environment']['php_versions'] = []
override['travis_build_environment']['php_default_version'] = []
override['travis_build_environment']['php_aliases'] = {}

override['travis_build_environment']['hhvm_enabled'] = false

override['travis_build_environment']['elixir_versions'] = elixirs
override['travis_build_environment']['default_elixir_version'] = elixirs.max

override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '4.8'

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_packer_templates']['job_board']['stack'] = 'opal'

override['travis_postgresql']['default_version'] = '9.6'
override['travis_postgresql']['alternate_versions'] = %w[9.4 9.5 10]
override['travis_postgresql']['enabled'] = false # is default instance started on machine boot?

override['travis_packer_templates']['job_board']['features'] = %w[
  basic
  couchdb
  disabled-ipv6
  docker
  docker-compose
  elasticsearch
  firefox
  go-toolchain
  google-chrome
  jdk
  memcached
  mongodb
  mysql
  nodejs_interpreter
  perl_interpreter
  perlbrew
  phantomjs
  postgresql
  python_interpreter
  redis
  ruby_interpreter
  sqlite
  xserver
]
override['travis_packer_templates']['job_board']['languages'] = %w[
  __opal__
  crystal
  csharp
  d
  dart
  elixir
  erlang
  haskell
  haxe
  julia
  perl
  perl6
  r
  rust
]

override['travis_docker']['version'] = '5:20.10.7~3-0~ubuntu-xenial'
override['travis_docker']['binary']['version'] = '20.10.7'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'f3f10cf3dbb8107e9ba2ea5f23c1d2159ff7321d16f0a23051d68d8e2547b323'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-20.10.7.tgz'
override['travis_docker']['binary']['checksum'] = '34ad50146fce29b28e5115a1e8510dd5232459c9a4a9f28f65909f92cca314d9'
