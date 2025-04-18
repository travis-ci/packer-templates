# frozen_string_literal: true

override['maven']['install_java'] = false

default['travis_ci_sardonyx']['prerequisite_packages'] = %w[
  cron
  curl
  git
  sudo
  wget
]

override['travis_build_environment']['pip']['packages'] = {} # need to fill in

override['travis_system_info']['commands_file'] = \
  '/var/tmp/sardonyx-system-info-commands.yml'

php_aliases = {
  '7.4' => '7.4.30'
}
override['travis_build_environment']['php_versions'] = php_aliases.values
override['travis_build_environment']['php_default_version'] = php_aliases['7.4']
override['travis_build_environment']['php_aliases'] = php_aliases

if node['kernel']['machine'] == 'ppc64le'
  override['travis_build_environment']['php_versions'] = []
  override['travis_build_environment']['php_default_version'] = []
  override['travis_build_environment']['php_aliases'] = {}

  # TODO: remove if/when an HHVM version is available on ppc64
  override['travis_build_environment']['hhvm_enabled'] = false
end

override['travis_perlbrew']['perls'] = [{ name: '5.34.1', version: 'perl-5.34.1' }, { name: '5.36.0', version: 'perl-5.36.0' }]

override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

go_versions = %w[
  1.23
]
# override['travis_build_environment']['virtualenv']['version'] = '20.15.1'
override['travis_build_environment']['go']['versions'] = go_versions
override['travis_build_environment']['go']['default_version'] = go_versions.max

if node['kernel']['machine'] == 'ppc64le'
  override['travis_java']['default_version'] = 'openjdk8'
else
  override['travis_jdk']['versions'] = %w[
    openjdk8
    openjdk11
  ]
  override['travis_jdk']['default'] = 'openjdk11'
end

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['nodejs_versions'] = %w[
  16.16.0
]
override['travis_build_environment']['nodejs_default'] = '16.16.0'

override['travis_build_environment']['system_python']['pythons'] = %w[2.7]
override['travis_build_environment']['python_aliases'] = {
  '2.7.18' => %w[2.7],
  '3.7.17' => %w[3.7],
  '3.8.13' => %w[3.8],
  'pypy2.7-7.3.16' => %w[pypy],
  'pypy3.7-7.3.9' => %w[pypy3]
}

pythons = %w[
  2.7.18
  3.7.17
  3.8.13
]

override['travis_build_environment']['clang']['version'] = '7.0.0'
override['travis_build_environment']['clang']['download_url'] = ::File.join(
  'http://releases.llvm.org',
  node['travis_build_environment']['clang']['version'],
  "clang+llvm-#{node['travis_build_environment']['clang']['version']}-x86_64-linux-gnu-ubuntu-16.04.tar.xz"
)
override['travis_build_environment']['clang']['checksum'] = '69b85c833cd28ea04ce34002464f10a6ad9656dd2bba0f7133536a9927c660d2'

# Reorder pythons so that default python2 and python3 come first
# as this affects the ordering in $PATH.
%w[3].each do |pyver|
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
  2.7.6
  3.3.5
]

override['travis_build_environment']['default_ruby'] = '3.3.5'
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = []
override['travis_build_environment']['elixir_versions'] = []
override['travis_build_environment']['default_elixir_version'] = ''

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '5.9.3'

override['travis_packer_templates']['job_board']['stack'] = 'sardonyx'

override['travis_build_environment']['ibm_advanced_tool_chain_version'] = 12.0

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
  __sardonyx__
  c
  c++
  clojure
  cplusplus
  cpp
  default
  generic
  go
  groovy
  java
  node_js
  php
  pure_java
  python
  ruby
  scala
]

override['travis_docker']['version'] = '5:20.10.7~3-0~ubuntu-xenial'
override['travis_docker']['binary']['version'] = '20.10.7'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'f3f10cf3dbb8107e9ba2ea5f23c1d2159ff7321d16f0a23051d68d8e2547b323'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-20.10.7.tgz'
override['travis_docker']['binary']['checksum'] = '34ad50146fce29b28e5115a1e8510dd5232459c9a4a9f28f65909f92cca314d9'
