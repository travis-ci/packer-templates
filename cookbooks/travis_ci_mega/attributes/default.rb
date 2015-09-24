default['travis_ci_mega']['prerequisite_packages'] = %w(
  cron
  curl
  git
  sudo
  wget
)

override['rvm']['rubies'] = ['2.2.3']

override['travis_rvm']['latest_minor'] = true
override['travis_rvm']['default'] = '2.2.3'
override['travis_rvm']['rubies'] = [
  # { 'name' => '1.8.7', 'arguments' => '--binary --fuzzy' },
  { 'name' => '1.8.7-p374' },
  { 'name' => '1.9.3-p551', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.0.0-p647', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.1.7', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.2.3', 'arguments' => '--binary --fuzzy' },
  # { 'name' => 'jruby-1.7.20-d18', 'arguments' => '--18',
  #   'check_for' => 'jruby-d18' },
  # { 'name' => 'jruby-1.7.20-d19', 'arguments' => '--19',
  #   'check_for' => 'jruby-d19' },
  { 'name' => 'jruby-9.0.0.0' },
  # { 'name' => 'ree' },
]
override['travis_rvm']['gems'] = %w(
  bundler
  rake
)
override['travis_rvm']['aliases'] = {
  # 'jruby-d18' => 'jruby-1.7.20-d18',
  # 'jruby-d19' => 'jruby-1.7.20-d19',
  # 'jruby-18mode' => 'jruby-d18',
  # 'jruby-19mode' => 'jruby-d19',
  'jruby' => 'jruby-9.0.0.0',
  '1.8' => 'ruby-1.8.7-p374',
  '1.9' => 'ruby-1.9.3-p551',
  '2.0' => 'ruby-2.0.0-p647',
  '2.1' => 'ruby-2.1.7',
  '2.2' => 'ruby-2.2.3'
}

override['gimme']['versions'] = %w(
  1.0.3
  1.1.2
  1.2.2
  1.3.3
  1.4.2
  1.5.1
)
override['gimme']['default_version'] = '1.5.1'

override['java']['default_version'] = 'oraclejdk7'
override['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  openjdk8
  oraclejdk8
)

override['nodejs']['versions'] = %w(
  0.6.21
  0.8.28
  0.10.40
  0.11.16
  0.12.7
  4.0.0
)
override['nodejs']['aliases'] = {
  '0.10' => '0.1',
  '0.11.16' => 'node-unstable'
}
override['nodejs']['default'] = '4.0.0'

override['python']['pyenv']['pythons'] = %w(
  2.6.9
  2.7.10
  3.2.6
  3.3.6
  3.4.3
  3.5.0
  pypy-2.6.1
  pypy3-2.4.0
)
override['python']['pyenv']['aliases'] = {
  '2.6.9' => %w(2.6),
  '2.7.10' => %w(2.7),
  '3.2.6' => %w(3.2),
  '3.3.6' => %w(3.3),
  '3.4.3' => %w(3.4),
  '3.5.0' => %w(3.5),
  'pypy-2.6.1' => %w(pypy),
  'pypy3-2.4.0' => %w(pypy3)
}

override['travis_build_environment']['use_tmpfs_for_builds'] = false

override['rabbitmq']['enabled_plugins'] = %w(rabbitmq_management)
