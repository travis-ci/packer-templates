default['rvm']['latest_minor'] = true
default['rvm']['default'] = '2.2.2'
default['rvm']['rubies'] = [
  { 'name' => '1.9.3' },
  { 'name' => '2.0.0' },
  { 'name' => '2.1.6' },
  { 'name' => '2.2.2' },
  { 'name' => 'jruby-1.7.20-d18', 'arguments' => '--18', 'check_for' => 'jruby-d18' },
  { 'name' => 'jruby-1.7.20-d19', 'arguments' => '--19', 'check_for' => 'jruby-d19' },
  { 'name' => 'jruby-9.0.0.0.rc1' },
  { 'name' => 'ree' },
]
default['rvm']['gems'] = %w(
  bundler
  rake
)
default['rvm']['aliases'] = {
  'jruby-d18' => 'jruby-1.7.20-d18',
  'jruby-d19' => 'jruby-1.7.20-d19',
  'jruby-18mode' => 'jruby-d18',
  'jruby-19mode' => 'jruby-d19',
  'jruby' => 'jruby-19mode',
  '2.0' => 'ruby-2.0.0',
  '2.1' => 'ruby-2.1.6',
  '2.2' => 'ruby-2.2.2'
}

default['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  oraclejdk8
)

default['nodejs']['versions'] = %w(
  0.6.21
  0.8.28
  0.10.18
  0.10.39
  0.11.16
  0.12.6
)
default['nodejs']['aliases'] = {
  '0.10' => '0.1',
  '0.11.16' => 'node-unstable'
}
default['nodejs']['default'] = '0.12.6'

default['python']['pyenv']['pythons'] = %w(
  2.7.10
  2.6.9
  3.2.6
  3.3.6
  3.4.3
  pypy-2.6.0
  pypy3-2.4.0
)
default['python']['pyenv']['aliases'] = {
  '2.6.9' => %w(2.6),
  '2.7.10' => %w(2.7),
  '3.2.6' => %w(3.2),
  '3.3.6' => %w(3.3),
  '3.4.3' => %w(3.4),
  'pypy-2.6.0' => %w(pypy),
  'pypy3-2.4.0' => %w(pypy3),
}

# NOTE: the php::multi attributes are *very special* and differ greatly between
# precise and trusty.  Please consult the php::default attributes for details.

default['hhvm']['package']['disabled'] = true
if node['lsb']['codename'] == 'trusty'
  default['hhvm']['package']['disabled'] = false
end

default['composer']['github_oauth_token'] = '2d8490a1060eb8e8a1ae9588b14e3a039b9e01c6'
