default['rvm']['default'] = '2.2.6'
default['rvm']['rubies'] = [
  { name: '2.2.6', arguments: '--binary --fuzzy' }
]
default['rvm']['gems'] = %w(nokogiri)

gimme_versions = %w(
  1.4.2
)

override['gimme']['versions'] = gimme_versions
override['gimme']['default_version'] = gimme_versions.max

default['python']['pyenv']['pythons'] = []

default['travis_build_environment']['use_tmpfs_for_builds'] = false

default['travis_ci_standard']['standalone'] = false
