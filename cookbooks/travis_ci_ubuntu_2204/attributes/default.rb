# frozen_string_literal: true

override['maven']['install_java'] = false
override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-2204-system-info-commands.yml'
override['travis_build_environment']['system_python']['pythons'] = %w[3.10] # apt packages
override['travis_build_environment']['python_aliases'] = {
  '3.12.4' => %w[3.12],
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
  3.12.4
]

%w[3].each do |pyver|
  pythons.select { |p| p =~ /^#{pyver}/ }.max.tap do |py|
    pythons.unshift(pythons.delete(py))
  end
end

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

go_versions = %w[
  1.23
]

override['travis_build_environment']['clang']['version'] = '18.1.8'
override['travis_build_environment']['clang']['download_url'] = ::File.join(
  "https://github.com/llvm/llvm-project/releases/download/llvmorg-#{node['travis_build_environment']['clang']['version']}",
  "clang+llvm-#{node['travis_build_environment']['clang']['version']}-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
)

override['travis_build_environment']['clang']['checksum'] = '54ec30358afcc9fb8aa74307db3046f5187f9fb89fb37064cdde906e062ebf36'	


override['travis_build_environment']['shfmt_url'] = 'https://github.com/mvdan/sh/releases/download/v3.8.0/shfmt_v3.8.0_linux_amd64'
override['travis_build_environment']['shfmt_checksum'] = '27b3c6f9d9592fc5b4856c341d1ff2c88856709b9e76469313642a1d7b558fe0'

override['travis_build_environment']['go']['versions'] = go_versions
override['travis_build_environment']['go']['default_version'] = go_versions.max

override['travis_jdk']['versions'] = %w[
  openjdk8
  openjdk11
  openjdk17
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
  16.20.2
  18.20.3
]
override['travis_build_environment']['nodejs_default'] = '18.20.3'

rubies = %w[
  2.7.8
  3.3.5
]

override['travis_build_environment']['virtualenv']['version'] = '20.24.6'


# changing default ruby version due to dpl issues
override['travis_build_environment']['default_ruby'] = '3.3.5'
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  25.3.2.6
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
override['travis_build_environment']['mercurial_version'] = '6.5.2'
override['travis_build_environment']['ibm_advanced_tool_chain_version'] = 14.0

override['travis_build_environment']['packer']['amd64']['version'] = '1.11.2'
override['travis_build_environment']['packer']['amd64']['checksum'] = \
'ced13efc257d0255932d14b8ae8f38863265133739a007c430cae106afcfc45a'

override['travis_packer_templates']['job_board']['stack'] = 'ubuntu_2204'

override['travis_build_environment']['firefox_version'] = '99.0'

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
  node_js
  smalltalk
  shell
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
