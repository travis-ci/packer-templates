# frozen_string_literal: true

override['maven']['install_java'] = false
override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-2204-system-info-commands.yml'
override['travis_build_environment']['system_python']['pythons'] = %w[3.10] # apt packages
override['travis_build_environment']['python_aliases'] = {
  '3.12.2' => %w[3.12],
  '3.10.14' => %w[3.10],
  '3.8.18' => %w[3.8],
  '3.7.17' => %w[3.7],
  'pypy2.7-7.3.1' => %w[pypy],
  'pypy3.6-7.3.1' => %w[pypy3],
}
# packages build by Cpython + our repo
pythons = %w[
  3.7.17
  3.8.18
  3.10.14
  3.12.2
]
override['travis_build_environment']['pythons'] = pythons

override['travis_build_environment']['pip']['packages'] = {} # need to fill in

# our php builder
php_aliases = {
  '8.1' => '8.1.2'
}
override['travis_build_environment']['php_versions'] = php_aliases.values
override['travis_build_environment']['php_default_version'] = php_aliases['8.1']
override['travis_build_environment']['php_aliases'] = php_aliases

override['travis_perlbrew']['perls'] = [{ name: '5.33.0', version: 'perl-5.33.0' }, { name: '5.34.0', version: 'perl-5.34.0' }]
override['travis_perlbrew']['prerequisite_packages'] = []

gimme_versions = %w[
  1.18.3
]

	
override['travis_build_environment']['shfmt_url'] = 'https://github.com/mvdan/sh/releases/download/v3.7.0/shfmt_v3.7.0_linux_amd64'
default['travis_build_environment']['shfmt_checksum'] = '0264c424278b18e22453fe523ec01a19805ce3b8ebf18eaf3aadc1edc23f42e3'

override['travis_build_environment']['gimme']['versions'] = gimme_versions
override['travis_build_environment']['gimme']['default_version'] = gimme_versions.max

override['travis_jdk']['versions'] = %w[
  openjdk8
  openjdk11
  openjdk17
]

override['travis_jdk']['default'] = 'openjdk11'

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['cmake']['version'] = '3.26.3'
override['travis_build_environment']['cmake']['checksum'] = '28d4d1d0db94b47d8dfd4f7dec969a3c747304f4a28ddd6fd340f553f2384dc2'
override['travis_build_environment']['cmake']['download_url'] = ::File.join(
  'https://cmake.org/files',
  "v#{node['travis_build_environment']['cmake']['version'].split('.')[0, 2].join('.')}",
  "cmake-#{node['travis_build_environment']['cmake']['version']}-linux-x86_64.tar.gz"
)

override['travis_build_environment']['nodejs_versions'] = %w[
  16.20.2
  18.18.2
]
override['travis_build_environment']['nodejs_default'] = '18.18.2'

rubies = %w[
  2.7.8
  3.1.2
  3.3.0
]

override['travis_build_environment']['virtualenv']['version'] = '20.24.6'


# changing default ruby version due to dpl issues
override['travis_build_environment']['default_ruby'] = '3.3.0'
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  24.2.1
]
elixirs = %w[
  1.12.2
]
override['travis_build_environment']['elixir_versions'] = elixirs
override['travis_build_environment']['default_elixir_version'] = elixirs.max

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '5.3'
override['travis_build_environment']['ibm_advanced_tool_chain_version'] = 14.0

override['travis_build_environment']['packer']['amd64']['version'] = '1.9.4'
override['travis_build_environment']['packer']['amd64']['checksum'] = \
'6cd5269c4245aa8c99e551d1b862460d63fe711c58bec618fade25f8492e80d9'

override['travis_packer_templates']['job_board']['stack'] = 'ubuntu_2204'

# not yet supported
override['travis_postgresql']['default_version'] = '14'
override['travis_postgresql']['alternate_versions'] = %w[]
override['travis_postgresql']['enabled'] = false # is default instance started on machine boot?

override['travis_packer_templates']['job_board']['features'] = %w[
  basic
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
  __ubuntu_2204__
  c
  c++
  cplusplus
  cpp
  ruby
  python
  go
  java
  php
  generic
  shell
  node_js
  smalltalk
  shell
  csharp
  perl
  rust
  elixir
  erlang
]

override['travis_docker']['version'] = '24.0.5'
override['travis_docker']['binary']['version'] = '24.0.5'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-Linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'f45e4cb687df8b48a57f656097ce7175fa8e8bef70be407b011e29ff663f475f'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-24.0.5.tgz'
override['travis_docker']['binary']['checksum'] = '0a5f3157ce25532c5c1261a97acf3b25065cfe25940ef491fa01d5bea18ddc86'