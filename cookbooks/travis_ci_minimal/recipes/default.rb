# Cookbook Name:: travis_ci_minimal
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH <contact+packer-templates@travis-ci.org>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

execute 'apt-get -o Acquire::CompressionTypes::Order::=bz2 update -yqq'

include_recipe 'travis_build_environment'
include_recipe 'apt'

Array(node['travis_build_environment']['packages']).each_slice(10) do |slice|
  package slice do
    retries 2
    action [:install, :upgrade]
  end
end

include_recipe 'clang::tarball'
include_recipe 'sysctl'
include_recipe 'travis_git::ppa'
include_recipe 'jq'

unless node['travis_packer_templates']['env']['PACKER_BUILDER_TYPE'] == 'docker'
  include_recipe 'travis_docker'
  include_recipe 'travis_docker::compose'
end

include_recipe 'travis_libevent'
include_recipe 'gimme'
include_recipe 'travis_java::multi'
include_recipe 'nodejs::multi'
include_recipe 'travis_php::multi'
include_recipe 'travis_perlbrew::multi'
include_recipe 'postgresql::pgdg'
include_recipe 'python::pyenv'
include_recipe 'rvm::system'
include_recipe 'travis_rvm::multi'
include_recipe 'system_info'
include_recipe 'sweeper'
