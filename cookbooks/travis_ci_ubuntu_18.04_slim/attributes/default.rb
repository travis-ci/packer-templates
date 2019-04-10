# frozen_string_literal: true

override['maven']['install_java'] = false

default['travis_ci_ubuntu-18.04-slim']['prerequisite_packages'] = %w[
  cron
  curl
  git
  sudo
  wget
]

override['travis_system_info']['commands_file'] = \
  '/var/tmp/ubuntu-18.04-slim-system-info-commands.yml'

override['travis_build_environment']['php_versions'] = []
override['travis_build_environment']['php_default_version'] = []
override['travis_build_environment']['php_aliases'] = {}

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

override['travis_build_environment']['gimme']['versions'] = []
override['travis_build_environment']['gimme']['default_version'] = ''

if node['kernel']['machine'] == 'ppc64le'
  override['travis_java']['default_version'] = 'openjdk8'
  override['travis_java']['alternate_versions'] = %w[openjdk7]
else
  override['travis_jdk']['versions'] = %w[openjdk11]
  override['travis_jdk']['default'] = 'openjdk11'
end

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['pythons'] = []
override['travis_build_environment']['python_aliases'] = {}
override['travis_build_environment']['pip']['packages'] = {}
override['travis_build_environment']['system_python']['pythons'] = []

override['travis_build_environment']['nodejs_default'] = ''
override['travis_build_environment']['nodejs_versions'] = []
override['travis_build_environment']['nodejs_aliases'] = {}
override['travis_build_environment']['nodejs_default_modules'] = []

override['travis_build_environment']['default_ruby'] = ''
override['travis_build_environment']['rubies'] = []

override['travis_build_environment']['otp_releases'] = []
override['travis_build_environment']['elixir_versions'] = []
override['travis_build_environment']['default_elixir_version'] = ''

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['update_hostname'] = true if node['kernel']['machine'] == 'ppc64le'
override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '4.8'

override['travis_postgresql']['default_version'] = '9.6'
override['travis_postgresql']['alternate_versions'] = %w[9.4 9.5 10]
override['travis_postgresql']['enabled'] = false # is default instance started on machine boot?
