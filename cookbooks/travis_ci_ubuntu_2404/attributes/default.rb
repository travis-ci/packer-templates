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

override['travis_build_environment']['go']['versions'] = go_versions
override['travis_build_environment']['go']['default_version'] = go_versions.max

override['travis_jdk']['versions'] = %w[
  openjdk17
  openjdk21
  openjdk24
]

override['travis_jdk']['default'] = 'openjdk17'

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['nodejs_versions'] = %w[
  16.20.2
  18.20.3
]
override['travis_build_environment']['nodejs_default'] = '18.20.3'

rubies = %w[
  3.3.9
]

# changing default ruby version due to dpl issues
override['travis_build_environment']['default_ruby'] = '3.3.9'
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['otp_releases'] = %w[
  26.1.1
]
elixirs = %w[
  1.18.4
]
override['travis_build_environment']['elixir_versions'] = elixirs
override['travis_build_environment']['default_elixir_version'] = elixirs.max

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_build_environment']['mercurial_install_type'] = 'apt'
override['travis_build_environment']['mercurial_version'] = '7.0.3'
override['travis_build_environment']['ibm_advanced_tool_chain_version'] = 16.0

override['travis_packer_templates']['job_board']['stack'] = 'ubuntu_2404'

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
  scala
  csharp
  dart
  perl
  rust
  elixir
  erlang
]

override['travis_docker']['update_grub'] = false
override['travis_docker']['version'] = '28.3.3'
override['travis_docker']['binary']['version'] = '28.3.3'
override['travis_docker']['compose']['url'] = 'https://github.com/docker/compose/releases/download/v2.39.1/docker-compose-linux-x86_64'
override['travis_docker']['compose']['sha256sum'] = 'a5ea28722d5da628b59226626f7d6c33c89a7ed19e39f750645925242044c9d2'
override['travis_docker']['binary']['url'] = 'https://download.docker.com/linux/static/stable/x86_64/docker-28.3.3.tgz'
override['travis_docker']['binary']['checksum'] = '40c16bcf324f354b382d07e845e6a79e3493fc0c09b252dff9e1a46125589bff'

override['android-sdk'] = {
  'name' => 'android-sdk',
  'setup_root' => '/usr/local',
  'download_url' => 'https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip',
  'checksum' => '2b3751867a4b4b70dbd8dcf6537aa888',
  'version' => '9477386',
  'owner' => 'root',
  'group' => 'root',
  'with_symlink' => true,
  'java_from_system' => false,
  'set_environment_variables' => true,
  'license' => {
    'white_list' => ['android-sdk-license'],
    'black_list' => [],
    'default_answer' => 'y'
  },
  'license_file_path' => File.expand_path('../../android-accept-licenses', __dir__),
  'components' => [
    'tools',
    'platform-tools',
    'build-tools;30.0.0',    
    'platforms;android-30', 
    'extras;google;google_play_services',
    'extras;google;m2repository',
    'extras;android;m2repository'
  ],
  'scripts' => {
    'path' => '/usr/local/bin',
    'owner' => 'root',
    'group' => 'root'
  },
  'maven_rescue' => false
}
