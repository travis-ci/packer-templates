override['travis_packer_templates']['job_board']['codename'] = 'haskell'
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
override['travis_packer_templates']['job_board']['languages'] = %w(haskell)
