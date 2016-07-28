override['python']['pyenv']['pythons'] = %w(
  2.6.9
  2.7.9
  3.2.5
  3.3.5
  3.4.2
  3.5.0
  pypy-2.6.1
  pypy3-2.4.0
)
override['travis_packer_templates']['job_board']['codename'] = 'python'
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
override['travis_packer_templates']['job_board']['languages'] = %w(python)
