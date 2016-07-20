# Cookbook Name:: travis_ci_amethyst
# Recipe:: default
#
# Copyright 2016, Travis CI GmbH
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

include_recipe 'apt'
include_recipe 'travis_build_environment::apt'
include_recipe 'travis_packer_templates'
include_recipe 'travis_build_environment'
include_recipe 'clang::tarball'
include_recipe 'travis_cmake'
include_recipe 'sysctl'
include_recipe 'travis_git::ppa'
include_recipe 'travis_git::lfs'
include_recipe 'travis_build_environment::packer'
include_recipe 'travis_build_environment::bats'
include_recipe 'travis_build_environment::heroku_toolbelt'

unless node['travis_packer_templates']['env']['PACKER_BUILDER_TYPE'] == 'docker'
  include_recipe 'travis_docker'
  include_recipe 'travis_docker::compose'
end

include_recipe 'wget'
include_recipe 'openssl'
include_recipe 'mercurial'
include_recipe 'bazaar'
include_recipe 'subversion'
include_recipe 'scons'
include_recipe 'unarchivers'
include_recipe 'md5deep'
include_recipe 'dictionaries'
include_recipe 'sqlite'
include_recipe 'postgresql'
include_recipe 'travis_python::pyenv'
include_recipe 'travis_python::system'
include_recipe 'nodejs::multi'
include_recipe 'nodejs::iojs'
include_recipe 'travis_perlbrew::multi'
include_recipe 'redis'
# include_recipe 'riak'
include_recipe 'travis_build_environment::mongodb'
# include_recipe 'couchdb::ppa'
include_recipe 'memcached'
# include_recipe 'neo4j-server::tarball'
# include_recipe 'cassandra::tarball'
include_recipe 'travis_build_environment::rabbitmq'
# include_recipe 'zeromq::ppa'
# include_recipe 'elasticsearch'
include_recipe 'travis_sphinxsearch'
include_recipe 'xserver'
include_recipe 'firefox::tarball'
include_recipe 'chromium'
include_recipe 'google-chrome'
include_recipe 'travis_phantomjs'
include_recipe 'travis_phantomjs::2'
include_recipe 'emacs::nox'
include_recipe 'vim'
include_recipe 'travis_system_info'
include_recipe 'sweeper'

include_recipe 'travis_python::devshm' unless
  node['travis_packer_templates']['env']['PACKER_BUILDER_TYPE'] == 'docker'
