default['travis_ci_garnet']['prerequisite_packages'] = %w(
  cron
  curl
  git
  sudo
  wget
)

override['travis_system_info']['commands_file'] = \
  '/var/tmp/garnet-system-info-commands.yml'

php_versions = %w(
  5.6.24
  7.0.7
)
override['travis_build_environment']['php_versions'] = php_versions
override['travis_build_environment']['php_aliases'] = {
  '5.6' => '5.6.24',
  '7.0' => '7.0.7'
}

gimme_versions = %w(
  1.6.3
)

override['travis_build_environment']['gimme']['versions'] = gimme_versions
override['travis_build_environment']['gimme']['default_version'] = gimme_versions.max

override['java']['jdk_version'] = '8'
override['java']['install_flavor'] = 'oracle'
override['java']['oracle']['accept_oracle_download_terms'] = true
override['java']['oracle']['jce']['enabled'] = true

override['travis_java']['default_version'] = 'oraclejdk8'
override['travis_java']['alternate_versions'] = %w(
  openjdk8
  oraclejdk9
)

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

node_versions = %w(
  4.4.7
  6.3.0
)

override['nodejs']['versions'] = node_versions
override['nodejs']['default'] = node_versions.max
override['nodejs']['default_modules'] = [
  {
    'module' => 'grunt-cli'
  }
]

pythons = %w(
  2.7.12
  3.5.2
)

# Reorder pythons so that default python2 and python3 come first
# as this affects the ordering in $PATH.
%w(3 2).each do |pyver|
  pythons.select { |p| p =~ /^#{pyver}/ }.max.tap do |py|
    pythons.unshift(pythons.delete(py))
  end
end

def python_aliases(full_name)
  nodash = full_name.split('-').first
  return [nodash] unless nodash.include?('.')
  [nodash[0, 3]]
end

override['travis_python']['pyenv']['pythons'] = pythons
pythons.each do |full_name|
  override['travis_python']['pyenv']['aliases'][full_name] = \
    python_aliases(full_name)
end

rubies = %w(
  2.2.5
  2.3.1
)

override['travis_build_environment']['default_ruby'] = rubies.reject { |n| n =~ /jruby/ }.max
override['travis_build_environment']['rubies'] = rubies

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_packer_templates']['job_board']['codename'] = 'garnet'
override['travis_packer_templates']['job_board']['features'] = %w(
  basic
  chromium
  docker
  docker-compose
  firefox
  go-toolchain
  google-chrome
  memcached
  mongodb
  nodejs_interpreter
  perl_interpreter
  phantomjs
  postgresql
  python_interpreter
  rabbitmq
  redis
  ruby_interpreter
  sqlite
  xserver
)
override['travis_packer_templates']['job_board']['languages'] = %w(
  __garnet__
  c
  c++
  clojure
  cplusplus
  cpp
  default
  go
  groovy
  java
  node_js
  php
  pure_java
  python
  ruby
  scala
)
