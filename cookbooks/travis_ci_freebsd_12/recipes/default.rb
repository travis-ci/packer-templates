# frozen_string_literal: true

# Cookbook Name:: travis_ci_2019
# Recipe:: default
#
# Copyright 2017, Travis CI GmbH
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

freebsd_package 'coreutils'
freebsd_package 'libunwind'

freebsd_package 'gcc10-devel'
freebsd_package 'cmake'
freebsd_package 'gmake'
freebsd_package 'gnulib'
freebsd_package 'autoconf'
freebsd_package 'automake'
freebsd_package 'ccache'

link '/usr/local/bin/gcc' do
  to '/usr/local/bin/gcc10'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

link '/usr/local/bin/g++' do
  to '/usr/local/bin/g++10'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

include_recipe '::create_bash_profile'

include_recipe '::pyenv'

include_recipe 'travis_build_environment::rvm'
include_recipe 'travis_build_environment::gimme'

freebsd_package 'openjdk8'
freebsd_package 'openjdk11'
freebsd_package 'openjdk12'
freebsd_package 'openjdk13'
freebsd_package 'maven'
freebsd_package 'gradle'
freebsd_package 'apache-ant'

include_recipe '::jdk_switcher'
