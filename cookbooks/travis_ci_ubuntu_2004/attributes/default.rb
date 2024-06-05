# frozen_string_literal: true

override['maven']['install_java'] = false
override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-2004-system-info-commands.yml'
override['travis_build_environment']['system_python']['pythons'] = %w[3.8] # apt packages
override['travis_build_environment']['python_aliases'] = {
  '3.12.0' => %w[3.12],
  '3.9.18' => %w[3.9],
  '3.8.18' => %w[3.8],
  '3.7.17' => %w[3.7],
  'pypy2.7-7.3.1' => %w[pypy],
  'pypy3.8-7.3.9' => %w[pypy3]
}
# packages build by Cpython + our repo
pythons = %w[
  3.7.17
  3.8.18
  3.9.18
  3.12.0
]
override['travis_build_environment']['pythons'] = pythons

override['travis_build_environment']['pip']['packages'] = {} # need to fill in

# our php builder
php_aliases = {
  '7.4' => '7.4.6'
}
override['travis_build_environment']['php_versions'] = php_aliases.values
override['travis_build_environment']['php_default_version'] = php_aliases['7.4']
override['travis_build_environment']['php_aliases'] = php_aliases

# TODO: remove if/when an HHVM version is available on ppc64
#  override['travis_build_environment']['hhvm_enabled'] = false
# end

override['travis_perlbrew']['perls'] = [{ name: '5.32.0', version: 'perl-5.32.0' }, { name: '5.33.0', version: 'perl-5.33.0' }]
override['travis_perlbrew']['prerequisite_packages'] = []

gimme_versions = %w[
  1.11.1
]

override['travis_build_environment']['gimme']['versions'] = gimme_versions
override['travis_build_environment']['gimme']['default_version'] = gimme_versions.max

override['travis_jdk']['versions'] = %w[
  openjdk8
  openjdk9
  openjdk10
  openjdk11
]
  
override['travis_jdk']['default'] = 'openjdk11'

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['cmake']['version'] = '3.29.0'
override['travis_build_environment']['cmake']['checksum'] = 'f06258f52c5649752dfb10c4c2e1d8167c760c8826f078c6f5c332fa9d976bf8'
override['travis_build_environment']['cmake']['download_url'] = ::File.join(
  'https://cmake.org/files',
  "v#{node['travis_build_environment']['cmake']['version'].split('.')[0, 2].join('.')}",
  "cmake-#{node['travis_build_environment']['cmake']['version']}-linux-x86_64.tar.gz"
)

override['travis_build_environment']['nodejs_versions'] = %w[
  18.20.3
]
override['travis_build_environment']['nodejs_default'] = '18.20.3'

rubies = %w[
  2.5.9
  2.7.6
  3.1.2
]

override['travis_build_environment']['virtualenv']['version'] = '20.24.6'

override['travis_build_environment']['default_ruby'] = '2.7.6'
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  25.3.2.6
]
elixirs = %w[
  1.7.4
]
override['travis_build_environment']['elixir_versions'] = elixirs
override['travis_build_environment']['default_elixir_version'] = elixirs.max

override['travis_build_environment']['shfmt_url'] = 'https://github.com/mvdan/sh/releases/download/v3.8.0/shfmt_v3.8.0_linux_amd64'
override['travis_build_environment']['shfmt_checksum'] = '27b3c6f9d9592fc5b4856c341d1ff2c88856709b9e76469313642a1d7b558fe0'

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '6.5.2'
override['travis_build_environment']['ibm_advanced_tool_chain_version'] = 14.0

override['travis_build_environment']['packer']['amd64']['version'] = '1.11.0'
override['travis_build_environment']['packer']['amd64']['checksum'] = \
'dcac06a4c671bbb71e916da5abe947ebf4d6aa35c197e21c7c7b1d68cb8b7cad'

override['travis_packer_templates']['job_board']['stack'] = 'ubuntu_2004'

override['travis_build_environment']['firefox_version'] = '99.0'

# not yet supported
override['travis_postgresql']['default_version'] = '12'
override['travis_postgresql']['alternate_versions'] = %w[13]
override['travis_postgresql']['enabled'] = false # is default instance started on machine boot?

override['travis_build_environment']['pyenv_revision'] = 'v2.3.24'

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

# Override values in array : minimal set of options
override['travis_packer_templates']['job_board']['features'] = %w[
  generic
  basic
  ruby_interpreter
]
# Set minimal languages
override['travis_packer_templates']['job_board']['languages'] = %w[
  __ubuntu_2004__
  c
  c++
  cplusplus
  cpp
  ruby
  python
  generic
  go
  shell
  java
  php
  node_js
  smalltalk
  csharp
  perl
  rust
  elixir
  erlang
]

override['travis_docker']['version'] = '26.1.3'
override['travis_docker']['binary']['version'] = '26.1.3'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-Linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'ddc876fe2a89d5b7ea455146b0975bfe52904eecba9b192193377d6f99d69ad9'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-26.1.3.tgz'
override['travis_docker']['binary']['checksum'] = 'a50076d372d3bbe955664707af1a4ce4f5df6b2d896e68b12ecc74e724d1db31'
