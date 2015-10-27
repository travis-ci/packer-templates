rubies = %w(
  1.9.3
)

default['rvm']['default'] = rubies.max
default['rvm']['rubies'] = rubies.map { |r| { 'name' => r } }
default['rvm']['gems'] = %w(nokogiri)

gimme_versions = %w(
  1.4.2
)

override['gimme']['versions'] = gimme_versions
override['gimme']['default_version'] = gimme_versions.max

default['python']['pyenv']['pythons'] = []

default['travis_build_environment']['use_tmpfs_for_builds'] = false

default['travis_ci_standard']['standalone'] = false
