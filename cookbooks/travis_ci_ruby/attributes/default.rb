override['rvm']['default'] = '2.2.5'
override['rvm']['rubies'] = %w(
  1.9.2
  1.9.3
  2.0.0
  2.1.10
  2.2.5
  2.3.1
).map { |name| { name: name, arguments: '--binary --fuzzy' } }

override['rvm']['gems'] = %w(
  bundler
  rake
)
override['rvm']['aliases'] = {
  '2.0' => 'ruby-2.0.0',
  '2.1' => 'ruby-2.1.5',
  '2.2' => 'ruby-2.2.5',
  '2.3' => 'ruby-2.3.1'
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
