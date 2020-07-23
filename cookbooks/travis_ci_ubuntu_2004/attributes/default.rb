# frozen_string_literal: true

override['maven']['install_java'] = false
override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-2004-system-info-commands.yml'
override['travis_build_environment']['system_python']['pythons'] = %w[3.8] # apt packages
override['travis_build_environment']['python_aliases'] = {
  '3.8.3' => %w[3.8],
  '3.7.7' => %w[3.7],
  'pypy2.7-7.3.1' => %w[pypy],
  'pypy3.6-7.3.1' => %w[pypy3]
}
# packages build by Cpython + our repo
pythons = %w[
  3.7.7
  3.8.3
]
override['travis_build_environment']['pythons'] = pythons
override['travis_build_environment']['virtualenv']['version'] = '20.0.20'

override['travis_build_environment']['pip']['packages'] = {} # need to fill in

# our php builder
php_aliases = {
  '7.4' => '7.4.6'
}
override['travis_build_environment']['php_versions'] = php_aliases.values
override['travis_build_environment']['php_default_version'] = php_aliases['7.4']
override['travis_build_environment']['php_aliases'] = php_aliases

# if node['kernel']['machine'] == "x86_64" # Is it required
# arch = 'amd64'
# else
# arch = node['kernel']['machine']
# end

# version = '7.6.0'
# override['travis_build_environment']['elasticsearch']['version'] = version
# override['travis_build_environment']['elasticsearch']['package_name'] = "elasticsearch-#{version}-#{arch}.deb"

# if node['kernel']['machine'] == 'ppc64le' # consider removing, for ppc64le creation we use bash scripts
#  override['travis_build_environment']['php_versions'] = []
#  override['travis_build_environment']['php_default_version'] = []
#  override['travis_build_environment']['php_aliases'] = {}

# TODO: remove if/when an HHVM version is available on ppc64
#  override['travis_build_environment']['hhvm_enabled'] = false
# end

override['travis_perlbrew']['perls'] = [ { name: '5.32.0', version: 'perl-5.32.0' }, { name: '5.33.0', version: 'perl-5.33.0' } ]
override['travis_perlbrew']['prerequisite_packages'] = []

gimme_versions = %w[
  1.11.1
]

override['travis_build_environment']['gimme']['versions'] = gimme_versions
override['travis_build_environment']['gimme']['default_version'] = gimme_versions.max

if node['kernel']['machine'] == 'ppc64le'
  override['travis_java']['default_version'] = 'openjdk8'
  override['travis_java']['alternate_versions'] = %w[openjdk7]
elsif node['kernel']['machine'] == 'aarch64'
  override['travis_build_environment']['arch'] = 'aarch64'
  override['travis_build_environment']['packer']['aarch64']['version'] = '1.3.3'
  override['travis_build_environment']['packer']['aarch64']['checksum'] = \
    'e08c9542ff6cb231dd03d6f8096f6749e79056734bf69d5399205451b94c9d03'
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

rubies = %w[
  2.5.7
  2.5.8
  2.6.5
  2.6.6
  2.7.0
  2.7.1
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
override['travis_build_environment']['mercurial_version'] = '5.3'

override['travis_packer_templates']['job_board']['stack'] = 'ubuntu_2004'

# not yet supported
override['travis_postgresql']['default_version'] = '12'
override['travis_postgresql']['alternate_versions'] = %w[]
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
  __ubuntu_2004__
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
  julia
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
  ruby
  python
  go
  java
  php
  node_js
  smalltalk
  csharp
  perl
]
