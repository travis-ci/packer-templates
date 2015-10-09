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

override['rvm']['group_users'] = %w(travis)
override['rvm']['install_rubies'] = false
override['rvm']['rubies'] = []
override['rvm']['rvmrc']['rvm_remote_server_url3'] = \
  'https://s3.amazonaws.com/travis-rubies/binaries'
override['rvm']['rvmrc']['rvm_remote_server_type3'] = 'rubies'
override['rvm']['rvmrc']['rvm_remote_server_verify_downloads3'] = '1'
override['rvm']['user_rubies'] = []
override['rvm']['user_install_rubies'] = false

rubies = [
  { 'name' => 'jruby-9.0.1.0' },
  { 'name' => '1.8.7-p374' },
  { 'name' => '1.9.3-p551', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.0.0-p647', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.1.7', 'arguments' => '--binary --fuzzy' },
  { 'name' => '2.2.3', 'arguments' => '--binary --fuzzy' }
]

ruby_names = rubies.map { |r| r['name'] }
mri_names = ruby_names.reject { |n| n =~ /jruby/ }

def ruby_alias(full_name)
  nodash = full_name.sub(/-.*/, '')
  return nodash unless nodash.include?('.')
  nodash[0, 3]
end

override['travis_rvm']['latest_minor'] = true
override['travis_rvm']['default'] = mri_names.max
override['travis_rvm']['rubies'] = rubies
override['travis_rvm']['gems'] = %w(bundler nokogiri rake)
ruby_names.each do |full_name|
  override['travis_rvm']['aliases'][ruby_alias(full_name)] = full_name
end

gimme_versions = %w(
  1.0.3
  1.1.2
  1.2.2
  1.3.3
  1.4.2
  1.5.1
)

override['gimme']['versions'] = gimme_versions
override['gimme']['default_version'] = gimme_versions.max

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

node_versions = %w(
  0.6.21
  0.8.28
  0.10.40
  0.11.16
  0.12.7
  4.1.2
)

override['nodejs']['versions'] = node_versions
override['nodejs']['aliases']['0.10'] = '0.1'
override['nodejs']['aliases']['0.11.16'] = 'node-unstable'
override['nodejs']['default'] = node_versions.max

pythons = %w(
  2.6.9
  2.7.10
  3.2.6
  3.3.6
  3.4.3
  3.5.0
  pypy-2.6.1
  pypy3-2.4.0
)

def python_aliases(full_name)
  nodash = full_name.sub(/-.*/, '')
  return [nodash] unless nodash.include?('.')
  [nodash[0, 3]]
end

override['python']['pyenv']['pythons'] = pythons
pythons.each do |full_name|
  override['python']['pyenv']['aliases'][full_name] = python_aliases(full_name)
end

override['rabbitmq']['enabled_plugins'] = %w(rabbitmq_management)

override['travis_build_environment']['update_hostname'] = false
override['travis_build_environment']['use_tmpfs_for_builds'] = false
