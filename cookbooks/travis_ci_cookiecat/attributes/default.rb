override['maven']['install_java'] = false

default['travis_ci_cookiecat']['prerequisite_packages'] = %w(
  cron
  curl
  git
  sudo
  wget
)

override['travis_system_info']['commands_file'] = \
  '/var/tmp/cookiecat-system-info-commands.yml'

override['java']['jdk_version'] = '8'
override['java']['install_flavor'] = 'oracle'
override['java']['oracle']['accept_oracle_download_terms'] = true
override['java']['oracle']['jce']['enabled'] = true

override['travis_java']['default_version'] = 'oraclejdk8'
override['travis_java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  openjdk8
  oraclejdk7
  oraclejdk9
)

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false
override['travis_packer_templates']['job_board']['stack'] = 'cookiecat'
override['travis_packer_templates']['job_board']['features'] = %w(
  basic
  disabled-ipv6
  docker
  docker-compose
  jdk
)
override['travis_packer_templates']['job_board']['languages'] = %w(
  __cookiecat__
  android
)
