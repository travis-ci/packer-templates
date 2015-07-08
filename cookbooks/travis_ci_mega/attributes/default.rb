override['rvm']['latest_minor'] = true
override['rvm']['default'] = '2.2.2'
override['rvm']['rubies'] = [
  { 'name' => '1.9.3' },
  { 'name' => '2.0.0' },
  { 'name' => '2.1.6' },
  { 'name' => '2.2.2' },
  { 'name' => 'jruby-1.7.20-d18', 'arguments' => '--18', 'check_for' => 'jruby-d18' },
  { 'name' => 'jruby-1.7.20-d19', 'arguments' => '--19', 'check_for' => 'jruby-d19' },
  { 'name' => 'jruby-9.0.0.0.rc1' },
  { 'name' => 'ree' },
]
override['rvm']['gems'] = %w(
  bundler
  rake
)
override['rvm']['aliases'] = {
  'jruby-d18' => 'jruby-1.7.20-d18',
  'jruby-d19' => 'jruby-1.7.20-d19',
  'jruby-18mode' => 'jruby-d18',
  'jruby-19mode' => 'jruby-d19',
  'jruby' => 'jruby-19mode',
  '2.0' => 'ruby-2.0.0',
  '2.1' => 'ruby-2.1.6',
  '2.2' => 'ruby-2.2.2'
}

override['gimme']['versions'] = %w(
  1.4.2
)
override['gimme']['default_version'] = '1.4.2'

override['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  oraclejdk8
)

override['nodejs']['versions'] = %w(
  0.6.21
  0.8.28
  0.10.18
  0.10.39
  0.11.16
  0.12.6
)
override['nodejs']['aliases'] = {
  '0.10' => '0.1',
  '0.11.16' => 'node-unstable'
}
override['nodejs']['default'] = '0.12.6'

override['python']['pyenv']['pythons'] = %w(
  2.7.10
  2.6.9
  3.2.6
  3.3.6
  3.4.3
  pypy-2.6.0
  pypy3-2.4.0
)
override['python']['pyenv']['aliases'] = {
  '2.6.9' => %w(2.6),
  '2.7.10' => %w(2.7),
  '3.2.6' => %w(3.2),
  '3.3.6' => %w(3.3),
  '3.4.3' => %w(3.4),
  'pypy-2.6.0' => %w(pypy),
  'pypy3-2.4.0' => %w(pypy3),
}

override['travis_build_environment']['use_tmpfs_for_builds'] = false
