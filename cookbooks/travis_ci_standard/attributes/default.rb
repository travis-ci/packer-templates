# default attributes
#

# rvm defaults

default['rvm']['default'] = 1.9.3
default['rvm']['rubies'] = {'name' => 1.9.3 }
default['rvm']['gems'] = ['nokogiri']

# gimme defaults
default['gimme']['versions'] = ['1.4.2']
default['gimme']['default_version'] = "1.4.2"

# python defaults
default['python']['pyenv']['pythons'] = []

# travis defaults
default['travis_build_environment']['use_tmpfs_for_builds'] = false

