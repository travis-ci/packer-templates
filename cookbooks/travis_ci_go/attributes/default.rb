override['gimme']['versions'] = %w(
  1.0.3
  1.1.2
  1.2.2
  1.3.3
  1.4.3
  1.5.4
  1.6.3
)
override['gimme']['default_version'] = '1.6.3'
override['travis_packer_templates']['job_board']['codename'] = 'go'
override['travis_packer_templates']['job_board']['features'] = %w(
  basic
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
override['travis_packer_templates']['job_board']['languages'] = %w(go)
