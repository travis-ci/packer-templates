override['rvm']['rubies'] = [
  { name: 'ree' }
] + (%w(
  1.8.7
  1.9.2
  1.9.3
  2.0.0
  2.1.2
  2.1.3
  2.1.4
  2.1.5
  2.2.0
).map { |name| { name: name, arguments: '--binary --fuzzy' } })

override['rvm']['gems'] = %w(
  bundler
  rake
)
override['rvm']['aliases'] = {
  '2.0' => 'ruby-2.0.0',
  '2.1' => 'ruby-2.1.5',
  '2.2' => 'ruby-2.2.0'
}
override['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  oraclejdk8
)
override['travis_packer_templates']['job_board']['codename'] = 'ruby'
override['travis_packer_templates']['job_board']['features'] = %w(
  basic
  chromium
  firefox
  google-chrome
  memcached
  mongodb
  nodejs_interpreter
  perl_interpreter
  phantomjs
  postgresql
  python_interpreter
  rabbitmq
  redis
  ruby_interpreter
  rvm
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
