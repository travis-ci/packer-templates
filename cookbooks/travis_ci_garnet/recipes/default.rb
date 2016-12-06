# Cookbook Name:: travis_ci_garnet
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

include_recipe 'travis_build_environment::apt'
include_recipe 'travis_packer_templates'
include_recipe 'travis_build_environment'

if node['travis_packer_templates']['env']['PACKER_BUILDER_TYPE'] == 'docker'
  include_recipe 'travis_docker::binary'
else
  include_recipe 'travis_docker'
  include_recipe 'travis_build_environment::ramfs'
end

include_recipe 'travis_docker::compose'
include_recipe 'openssl'
include_recipe 'scons'
include_recipe 'travis_java'
include_recipe 'maven'
include_recipe 'travis_build_environment::lein'
include_recipe 'travis_sbt_extras'
include_recipe 'gradle'
include_recipe 'postgresql'
include_recipe 'travis_build_environment::mysql'
include_recipe 'travis_python::pyenv'
include_recipe 'travis_python::system'
include_recipe 'nodejs::multi'
include_recipe 'nodejs::iojs'
include_recipe 'travis_perlbrew::multi'
include_recipe 'redis'
include_recipe 'travis_build_environment::mongodb'
include_recipe 'memcached'
include_recipe 'travis_build_environment::rabbitmq'
include_recipe 'travis_build_environment::xserver'
include_recipe 'firefox::tarball'
include_recipe 'google-chrome'
include_recipe 'travis_phantomjs'
include_recipe 'travis_phantomjs::2'
include_recipe 'emacs::nox'
include_recipe 'vim'
include_recipe 'travis_system_info'

# HACK: force removal of ~/.pearrc until a decision is reached on if they are
# good or bad
execute 'rm -f /home/travis/.pearrc'
