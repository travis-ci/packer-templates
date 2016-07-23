override['travis_packer_templates']['job_board']['codename'] = 'perl'
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
override['travis_packer_templates']['job_board']['languages'] = %w(
  perl
  perl6
)
