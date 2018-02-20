# frozen_string_literal: true

# Cookbook Name:: travis_internal_nat
# Recipe:: default
#
# Copyright 2018, Travis CI GmbH
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

include_recipe 'travis_internal_base'
include_recipe 'apt'
include_recipe 'iptables'
include_recipe 'openssh'
include_recipe 'openssh::iptables'
include_recipe 'travis_duo'

package %w[
  collectd
  collectd-utils
  conntrack
  curl
  fail2ban
  nfacct
  nftables
  pssh
  xtables-addons-common
] do
  action %i[install upgrade]
end

cookbook_file '/etc/collectd/collectd.conf' do
  owner 'root'
  group 'root'
  mode 0o644
end

service 'apparmor' do
  action %i[stop]
end

package %w[apparmor] do
  action %i[purge]
end

execute 'systemctl reset-failed apparmor' do
  action :nothing
end
