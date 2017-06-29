# frozen_string_literal: true

# Cookbook Name:: travis_tfw
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

require 'json'

include_recipe 'travis_internal_base'
include_recipe 'travis_docker'

package %w[
  lvm2
  xfsprogs
]

template '/usr/local/bin/travis-docker-volume-setup' do
  source 'travis-docker-volume-setup.sh.erb'
  owner 'root'
  group 'root'
  mode 0o755
  variables(
    device: node['travis_tfw']['docker_volume_device'],
    metadata_size: node['travis_tfw']['docker_volume_metadata_size']
  )
end

cookbook_file '/usr/local/bin/travis-tfw-combined-env' do
  owner 'root'
  group 'root'
  mode 0o755
end

template '/etc/default/docker-chef' do
  source 'etc-default-docker-chef.sh.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

file '/etc/default/docker' do
  content "# this space intentionally left blank\n"
  owner 'root'
  group 'root'
  mode 0o644
end

daemon_json = {
  'graph' => node['travis_tfw']['docker_dir'],
  'hosts' => %w[
    tcp://127.0.0.1:4243
    unix:///var/run/docker.sock
  ],
  'icc' => false,
  'userns-remap' => 'default'
}

file '/etc/docker/daemon.json' do
  content JSON.pretty_generate(daemon_json) + "\n"
  owner 'root'
  group 'root'
  mode 0o644
end

file '/etc/docker/daemon-direct-lvm.json' do
  content JSON.pretty_generate(
    daemon_json.merge(
      'storage-driver' => 'devicemapper',
      'storage-opts' => {
        'dm.basesize' => node['travis_tfw']['docker_dm_basesize'],
        'dm.datadev' => '/dev/direct-lvm/data',
        'dm.metadatadev' => '/dev/direct-lvm/metadata',
        'dm.fs' => node['travis_tfw']['docker_dm_fs']
      }.to_a.map { |pair| pair.join('=') }
    )
  ) + "\n"
  owner 'root'
  group 'root'
  mode 0o644
end

template '/etc/init/docker.conf' do
  source 'etc-init-docker.conf.erb'
  owner 'root'
  group 'root'
  mode 0o644
end

service 'docker' do
  action %i[enable start]
end
