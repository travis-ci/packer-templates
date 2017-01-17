override['rvm']['default'] = '2.2.6'
override['rvm']['rubies'] = %w(
  2.1.10
  2.2.6
  2.3.3
  2.4.0
).map { |name| { name: name, arguments: '--binary --fuzzy' } }

override['rvm']['gems'] = %w(
  bundler
  rake
)
override['rvm']['aliases'] = {
  '2.1' => 'ruby-2.1.10',
  '2.2' => 'ruby-2.2.6',
  '2.3' => 'ruby-2.3.3',
  '2.4' => 'ruby-2.4.0'
}
override['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  oraclejdk8
)
override['travis_packer_templates']['job_board']['stack'] = 'ruby'
override['travis_packer_templates']['job_board']['features'] = %w(
  basic
  chromium
  firefox
  google-chrome
  jdk
  memcached
  mongodb
  mysql
  nodejs_interpreter
  perl_interpreter
  phantomjs
  postgresql
  python_interpreter
  rabbitmq
  redis
  ruby_interpreter
  sphinxsearch
  sqlite
  xserver
)
override['travis_packer_templates']['job_board']['languages'] = %w(
  bash
  c
  c++
  cplusplus
  cpp
  crystal
  csharp
  d
  dart
  default
  generic
  haxe
  julia
  r
  ruby
  rust
  sh
  shell
)
