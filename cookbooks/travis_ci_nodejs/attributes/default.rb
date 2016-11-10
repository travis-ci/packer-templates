override['nodejs']['versions'] = %w(
  0.6.21
  0.8.27
  0.10.18
  0.10.36
  0.11.15
)
override['nodejs']['aliases']['0.10'] = '0.1'
override['nodejs']['aliases']['0.11.15'] = 'node-unstable'
override['nodejs']['default'] = '0.10.36'
override['travis_packer_templates']['job_board']['stack'] = 'nodejs'
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
override['travis_packer_templates']['job_board']['languages'] = %w(node_js)
