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
  { name: '5.26', version: 'perl-5.26.2' },
  { name: '5.26-extras', version: 'perl-5.26.2',
    arguments: '-Duseshrplib -Duseithreads', alias: '5.26-shrplib' },
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

override['travis_build_environment']['pythons'] = []

rubies = %w[
  2.4.5
  2.5.3
]

override['travis_build_environment']['default_ruby'] = rubies.reject { |n| n =~ /jruby/ }.max
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  21.1
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
