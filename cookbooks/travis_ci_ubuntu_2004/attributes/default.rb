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
  3.9.0
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

override['travis_perlbrew']['perls'] = [{ name: '5.32.0', version: 'perl-5.32.0' }, { name: '5.33.0', version: 'perl-5.33.0' }]
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
  override['travis_build_environment']['arch'] = 'arm64'
  override['travis_build_environment']['packer']['arm64']['version'] = '1.3.3'
  override['travis_build_environment']['packer']['arm64']['checksum'] = \
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

override['travis_build_environment']['cmake']['version'] = '3.16.8'
override['travis_build_environment']['cmake']['checksum'] = '6b5c856158c16307692ae54ba761cfe30df7b2a131d602e83fda42a572973063'
override['travis_build_environment']['cmake']['download_url'] = ::File.join(
  'https://cmake.org/files',
  "v#{node['travis_build_environment']['cmake']['version'].split('.')[0, 2].join('.')}",
  "cmake-#{node['travis_build_environment']['cmake']['version']}-Linux-x86_64.tar.gz"
)

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

override['travis_build_environment']['virtualenv']['version'] = '20.0.20'

override['travis_build_environment']['default_ruby'] = rubies.reject { |n| n =~ /jruby/ }.max
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  21.1
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
override['travis_build_environment']['ibm_advanced_tool_chain_version'] = 14.0

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
  erlang
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
  go
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

override['travis_docker']['version'] = '20.10.7'
override['travis_docker']['binary']['version'] = '20.10.7'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'f3f10cf3dbb8107e9ba2ea5f23c1d2159ff7321d16f0a23051d68d8e2547b323'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-20.10.7.tgz'
override['travis_docker']['binary']['checksum'] = '34ad50146fce29b28e5115a1e8510dd5232459c9a4a9f28f65909f92cca314d9'
