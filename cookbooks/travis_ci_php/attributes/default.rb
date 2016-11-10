override['rvm']['latest_minor'] = true
override['rvm']['default'] = '2.2.5'
override['rvm']['rubies'] = [
  { name: '2.2.5', arguments: '--binary --fuzzy' }
]
override['rvm']['gems'] = %w(
  bundler
  rake
)
override['composer']['github_oauth_token'] = '2d8490a1060eb8e8a1ae9588b14e3a039b9e01c6'
override['travis_packer_templates']['job_board']['stack'] = 'php'
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
override['travis_packer_templates']['job_board']['languages'] = %w(php)
