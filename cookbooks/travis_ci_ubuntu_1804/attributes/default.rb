# frozen_string_literal: true

override['maven']['install_java'] = false
override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-1804-system-info-commands.yml'
override['travis_build_environment']['system_python']['pythons'] = %w[3.6]
override['travis_build_environment']['python_aliases'] = {
  '3.6.15' => %w[3.6],
  '3.7.17' => %w[3.7],
  '3.8.13' => %w[3.8],
  'pypy3.7-7.3.9' => %w[pypy3]
}
php_aliases = {
  '7.1' => '7.1.33',
  '7.2' => '7.2.27',
  '7.3' => '7.3.14',
  '7.4' => '7.4.2'
}
override['travis_build_environment']['php_versions'] = php_aliases.values
override['travis_build_environment']['php_default_version'] = php_aliases['7.2']
override['travis_build_environment']['php_aliases'] = php_aliases
override['travis_build_environment']['ibm_advanced_tool_chain_version'] = 14.0

override['travis_build_environment']['virtualenv']['version'] = '20.15.1'

override['travis_build_environment']['elasticsearch']['version'] = '5.5.0'
if node['kernel']['machine'] == 'ppc64le'
  override['travis_build_environment']['php_versions'] = []
  override['travis_build_environment']['php_default_version'] = []
  override['travis_build_environment']['php_aliases'] = {}

  # TODO: remove if/when an HHVM version is available on ppc64
  override['travis_build_environment']['hhvm_enabled'] = false
end

override['travis_perlbrew']['perls'] = [{ name: '5.32.0', version: 'perl-5.32.0' }, { name: '5.33.0', version: 'perl-5.33.0' }]
override['travis_perlbrew']['prerequisite_packages'] = []

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

if node['kernel']['machine'] == 'ppc64le'
  override['travis_java']['default_version'] = 'openjdk8'
  override['travis_java']['alternate_versions'] = %w[openjdk7]
else
  override['travis_jdk']['versions'] = %w[
    openjdk8
    openjdk9
    openjdk10
    openjdk11
  ]
  override['travis_jdk']['default'] = 'openjdk11'
end

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['nodejs_versions'] = %w[
  16.15.1
]
override['travis_build_environment']['nodejs_default'] = '16.15.1'

pythons = %w[
  3.6.15
  3.7.17
  3.8.13
]

override['travis_build_environment']['pythons'] = pythons

rubies = %w[
  2.5.9
  2.6.9
  2.7.6
  3.1.2
]

override['travis_build_environment']['default_ruby'] = '2.7.6'
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  24.3.1
]
elixirs = %w[
  1.7.4
]
override['travis_build_environment']['elixir_versions'] = elixirs
override['travis_build_environment']['default_elixir_version'] = elixirs.max

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '5.3'

override['travis_packer_templates']['job_board']['stack'] = 'ubuntu_1804'

override['travis_postgresql']['default_version'] = '9.3'
override['travis_postgresql']['alternate_versions'] = %w[9.4 9.5 9.6 10 11]
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
  __ubuntu_1804__
  c
  c++
  clojure
  cplusplus
  cpp
  crystal
  default
  generic
  go
  groovy
  java
  node_js
  php
  pure_java
  python
  r
  ruby
  scala
  julia
  perl
  perl6
  elixir
  erlang

]
override['travis_docker']['version'] = '24.0.5'
override['travis_docker']['binary']['version'] = '24.0.5'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-Linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'f45e4cb687df8b48a57f656097ce7175fa8e8bef70be407b011e29ff663f475f'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-24.0.5.tgz'
override['travis_docker']['binary']['checksum'] = '0a5f3157ce25532c5c1261a97acf3b25065cfe25940ef491fa01d5bea18ddc86'
