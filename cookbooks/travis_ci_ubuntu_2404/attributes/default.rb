# frozen_string_literal: true

override['maven']['install_java'] = false
override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-2404-system-info-commands.yml'
override['travis_build_environment']['system_python']['pythons'] = %w[3.12] # apt packages
override['travis_build_environment']['python_aliases'] = {
  '3.13.1' => %w[3.13],
  '3.12.8' => %w[3.12],
  'pypy3.10-7.3.17' => %w[pypy3]
}
# packages build by Cpython + our repo
pythons = %w[
  3.12.8
  3.13.1
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
  '8.3' => '8.3.6'
}
override['travis_build_environment']['php_versions'] = php_aliases.values
override['travis_build_environment']['php_default_version'] = php_aliases['8.3']
override['travis_build_environment']['php_aliases'] = php_aliases

override['travis_perlbrew']['perls'] = [{ name: '5.36.0', version: 'perl-5.36.0' }, { name: '5.38.0', version: 'perl-5.38.0' }]
override['travis_perlbrew']['prerequisite_packages'] = []

# GO version must be without the minor version
go_versions = %w[
  1.24
]

override['travis_build_environment']['shfmt_url'] = 'https://github.com/mvdan/sh/releases/download/v3.9.0/shfmt_v3.9.0_linux_amd64'
override['travis_build_environment']['shfmt_checksum'] = 'd99b06506aee2ac9113daec3049922e70dc8cffb84658e3ae512c6a6cbe101b6'

override['travis_build_environment']['go']['versions'] = go_versions
override['travis_build_environment']['go']['default_version'] = go_versions.max

override['travis_jdk']['versions'] = %w[
  openjdk17
  openjdk21
  openjdk23
]

override['travis_jdk']['default'] = 'openjdk17'

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['cmake']['version'] = '3.30.0'
override['travis_build_environment']['cmake']['checksum'] = '09846a3858583f38189b59177586adf125a08c15f3cddcaf7d7d7081ac86969f'
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
  3.3.5
]

override['travis_build_environment']['virtualenv']['version'] = '20.29.1'

# changing default ruby version due to dpl issues
override['travis_build_environment']['default_ruby'] = '3.3.5'
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  26.1.1
]
elixirs = %w[
  1.18.2
]
override['travis_build_environment']['elixir_versions'] = elixirs
override['travis_build_environment']['default_elixir_version'] = elixirs.max

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_build_environment']['mercurial_install_type'] = 'apt'
override['travis_build_environment']['mercurial_version'] = ''
override['travis_build_environment']['ibm_advanced_tool_chain_version'] = 16.0

override['travis_build_environment']['packer']['amd64']['version'] = '1.12.0'
override['travis_build_environment']['packer']['amd64']['checksum'] = \
  'e859a76659570d1e29fa55396d5d908091bacacd4567c17770e616c4b58c9ace'

override['travis_packer_templates']['job_board']['stack'] = 'ubuntu_2404'

override['travis_build_environment']['firefox_version'] = '99.0'

# not yet supported
override['travis_postgresql']['default_version'] = '16'
override['travis_postgresql']['alternate_versions'] = %w[17]
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
  __ubuntu_2404__
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

override['travis_docker']['update_grub'] = false
override['travis_docker']['version'] = '27.5.1'
override['travis_docker']['binary']['version'] = '27.5.1'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-Linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'ed1917fb54db184192ea9d0717bcd59e3662ea79db48bff36d3475516c480a6b'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-27.5.1.tgz'
override['travis_docker']['binary']['checksum'] = '4f798b3ee1e0140eab5bf30b0edc4e84f4cdb53255a429dc3bbae9524845d640'
