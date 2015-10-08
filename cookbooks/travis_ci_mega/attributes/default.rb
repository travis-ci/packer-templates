default['travis_ci_mega']['prerequisite_packages'] = %w(
  cron
  curl
  git
  sudo
  wget
)

override['travis_phpenv']['prerequisite_recipes'] = []

override['travis_phpbuild']['prerequisite_recipes'] = []

override['travis_php']['multi']['versions'] = []
override['travis_php']['multi']['extensions'] = []
override['travis_php']['multi']['prerequisite_recipes'] = %w(
  bison
  travis_phpbuild
  travis_phpenv
)
override['travis_php']['multi']['postrequisite_recipes'] = %w(
  composer
  phpunit
)
override['travis_php']['multi']['binaries'] = []

override['composer']['github_oauth_token'] = \
  '2d8490a1060eb8e8a1ae9588b14e3a039b9e01c6'

override['travis_perlbrew']['perls'] = []
override['travis_perlbrew']['modules'] = []
override['travis_perlbrew']['prerequisite_packages'] = []

override['rvm']['default_ruby'] = 'ruby-2.2.3'
override['rvm']['group_users'] = %w(travis)
override['rvm']['rubies'] = ['2.2.3']
override['rvm']['rvmrc']['rvm_remote_server_url3'] = \
  'https://s3.amazonaws.com/travis-rubies/binaries'
override['rvm']['rvmrc']['rvm_remote_server_type3'] = 'rubies'
override['rvm']['rvmrc']['rvm_remote_server_verify_downloads3'] = '1'
override['rvm']['user_default_ruby'] = 'ruby-2.2.3'
override['rvm']['user_rubies'] = ['2.2.3']

override['travis_rvm']['latest_minor'] = true
override['travis_rvm']['default'] = '2.2.3'
override['travis_rvm']['rubies'] = [
  { 'name' => 'jruby-9.0.1.0' },
  { 'name' => '1.8.7-p374' },
  { 'name' => '1.9.3-p551', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.0.0-p647', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.1.7', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.2.3', 'arguments' => '--binary --fuzzy' }
]
override['travis_rvm']['gems'] = %w(
  bundler
  rake
)
override['travis_rvm']['aliases'] = {
  'jruby' => 'jruby-9.0.1.0',
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

override['java']['jdk_version'] = '8'
override['java']['install_flavor'] = 'oracle'
override['java']['oracle']['accept_oracle_download_terms'] = true
override['java']['oracle']['jce']['enabled'] = true

override['travis_java']['default_version'] = 'oraclejdk8'
override['travis_java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  openjdk8
  oraclejdk7
)

override['leiningen']['home'] = '/home/travis'
override['leiningen']['user'] = 'travis'

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

override['rabbitmq']['enabled_plugins'] = %w(rabbitmq_management)

override['travis_build_environment']['use_tmpfs_for_builds'] = false
