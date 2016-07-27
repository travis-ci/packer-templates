override['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  oraclejdk8
)
override['travis_packer_templates']['job_board']['codename'] = 'jvm'
override['travis_packer_templates']['job_board']['features'] = %w(
  chromium
  firefox
  google-chrome
  memcached
  mongodb
  phantomjs
  postgresql
  rabbitmq
  redis
  sphinxsearch
  sqlite
  xserver
)
override['travis_packer_templates']['job_board']['languages'] = %w(
  clojure
  groovy
  java
  pure_java
  scala
)
