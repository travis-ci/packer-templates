# frozen_string_literal: true

override['maven']['install_java'] = false

default['travis_ci_cookiecat']['prerequisite_packages'] = %w[
  cron
  curl
  git
  sudo
  wget
]

override['travis_phpenv']['prerequisite_recipes'] = []
override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

gimme_versions = %w[
  1.7.4
]

override['travis_build_environment']['gimme']['versions'] = gimme_versions
override['travis_build_environment']['gimme']['default_version'] = gimme_versions.max

override['travis_build_environment']['pythons'] = []
override['travis_build_environment']['python_aliases'] = {}
override['travis_build_environment']['pip']['packages'] = {}
override['travis_build_environment']['system_python']['pythons'] = []

override['travis_build_environment']['nodejs_default'] = ''
override['travis_build_environment']['nodejs_versions'] = []
override['travis_build_environment']['nodejs_aliases'] = {}
override['travis_build_environment']['nodejs_default_modules'] = []

rubies = %w[
  2.2.7
  2.4.1
]

override['travis_build_environment']['default_ruby'] = rubies.max
override['travis_build_environment']['rubies'] = rubies
override['travis_build_environment']['php_versions'] = []
override['travis_build_environment']['php_aliases'] = {}
override['travis_build_environment']['otp_releases'] = []
override['travis_build_environment']['elixir_versions'] = []
override['travis_build_environment']['default_elixir_version'] = ''
override['travis_build_environment']['hhvm_enabled'] = false
override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_build_environment']['install_gometalinter_tools'] = false
override['travis_build_environment']['mercurial_install_type'] = 'pip'
override['travis_build_environment']['mercurial_version'] = '4.2.2~trusty1'

override['travis_system_info']['commands_file'] = \
  '/var/tmp/cookiecat-system-info-commands.yml'

override['android-sdk']['java_from_system'] = true
override['android-sdk']['owner'] = 'travis'
override['android-sdk']['group'] = 'travis'
override['android-sdk']['license']['default_answer'] = 'y'
override['android-sdk']['scripts']['owner'] = 'travis'
override['android-sdk']['scripts']['group'] = 'travis'

override['travis_java']['default_version'] = 'oraclejdk8'
override['travis_java']['alternate_versions'] = %w[
  openjdk7
  openjdk8
]

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_packer_templates']['job_board']['stack'] = 'cookiecat'
override['travis_packer_templates']['job_board']['features'] = %w[
  basic
  disabled-ipv6
  docker
  docker-compose
  jdk
]
override['travis_packer_templates']['job_board']['languages'] = %w[
  __cookiecat__
  android
]
