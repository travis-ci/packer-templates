override['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  oraclejdk8
)
override['travis_packer_templates']['job_board']['stack'] = 'jvm'
override['travis_packer_templates']['job_board']['features'] = %w(
  basic
  chromium
  firefox
  google-chrome
  memcached
  mongodb
  mysql
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
