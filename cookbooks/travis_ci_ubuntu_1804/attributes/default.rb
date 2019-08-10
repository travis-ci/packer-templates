# frozen_string_literal: true

override['maven']['install_java'] = false
override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-1804-system-info-commands.yml'
override['travis_build_environment']['system_python']['pythons'] = %w[2.7 3.6]
override['travis_build_environment']['python_aliases'] = {
  '2.7.15' => %w[2.7],
  '3.6.7' => %w[3.6],
  'pypy2.7-5.8.0' => %w[pypy],
  'pypy3.5-5.8.0' => %w[pypy3]
}
php_aliases = {
  '7.1' => '7.1.30',
  '7.2' => '7.2.19',
  '7.3' => '7.3.6'
}
override['travis_build_environment']['php_versions'] = php_aliases.values
override['travis_build_environment']['php_default_version'] = php_aliases['7.2']
override['travis_build_environment']['php_aliases'] = php_aliases

if node['kernel']['machine'] == 'ppc64le'
  override['travis_build_environment']['php_versions'] = []
  override['travis_build_environment']['php_default_version'] = []
  override['travis_build_environment']['php_aliases'] = {}

  # TODO: remove if/when an HHVM version is available on ppc64
  override['travis_build_environment']['hhvm_enabled'] = false
end

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
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
    openjdk10
    openjdk11
  ]
  override['travis_jdk']['default'] = 'openjdk11'
end

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['nodejs_versions'] = %w[
  12.7.0
  10.16.0
]
override['travis_build_environment']['nodejs_default'] = '10.16.0'

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
  2.3.8
  2.4.5
  2.5.3
  2.6.3
]

override['travis_build_environment']['default_ruby'] = rubies.reject { |n| n =~ /jruby/ }.max
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = []
override['travis_build_environment']['elixir_versions'] = []
override['travis_build_environment']['default_elixir_version'] = ''

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '4.8'

override['travis_packer_templates']['job_board']['stack'] = 'ubuntu_1804'

override['travis_postgresql']['default_version'] = '9.3'
override['travis_postgresql']['alternate_versions'] = %w[9.4 9.5 9.6 10]
override['travis_postgresql']['enabled'] = false # is default instance started on machine boot?
override['travis_docker']['version'] = '19.03.1'
override['travis_docker']['binary']['binaries'] = %w[
  containerd
  containerd-shim
  ctr
  docker
  docker-init
  docker-proxy
  dockerd
  runc
]

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
