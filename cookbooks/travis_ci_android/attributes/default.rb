override['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  oraclejdk8
)

override['travis_packer_templates']['job_board']['codename'] = 'android'
override['travis_packer_templates']['job_board']['features'] = %w(
  chromium
  firefox
  google-chrome
  memcached
  phantomjs
  postgresql
  rabbitmq
  redis
  sphinxsearch
  sqlite
  xserver
)
override['travis_packer_templates']['job_board']['languages'] = %w(android)
