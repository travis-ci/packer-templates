# Cookbook Name:: travis_packer_templates
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

TravisPackerTemplates.new(node).init! if defined?(TravisPackerTemplates)

init_time = Time.now.utc

template '/etc/default/job-board-register' do
  source 'etc-default-job-board-register.sh.erb'
  cookbook 'travis_packer_templates'
  owner 'root'
  group 'root'
  mode 0o644
  variables(
    languages: node['travis_packer_templates']['job_board']['languages'],
    features: node['travis_packer_templates']['job_board']['features'],
    stack: node['travis_packer_templates']['job_board']['stack']
  )
end

template '/etc/profile.d/Z90-travis-packer-templates.sh' do
  source 'etc-profile-d-travis-packer-templates.sh.erb'
  cookbook 'travis_packer_templates'
  owner 'root'
  group 'root'
  mode 0o755
  variables(
    features: node['travis_packer_templates']['job_board']['features'],
    languages: node['travis_packer_templates']['job_board']['languages'],
    stack: node['travis_packer_templates']['job_board']['stack'],
    timestamp: init_time
  )
end

ruby_block 'write node attributes' do
  block do
    require 'json'
    require 'yaml'
    require 'fileutils'

    node_attributes_hash = JSON.parse(JSON.dump(node.attributes.to_hash))
    raise 'Empty node attributes' if node_attributes_hash.keys.empty?

    File.open('/.node-attributes.yml', 'w') do |f|
      f.puts YAML.dump(
        node_attributes_hash.merge('__timestamp' => init_time.to_s)
      )
    end

    FileUtils.chown('root', 'root', '/.node-attributes.yml')
    FileUtils.chmod(0o644, '/.node-attributes.yml')
  end

  action :nothing
end

log 'trigger writing node attributes' do
  notifies :run, 'ruby_block[write node attributes]'
end

file '/.job-board-register.yml' do
  content YAML.dump(
    JSON.parse(JSON.dump(node['travis_packer_templates']['job_board']))
  )
  owner 'root'
  group 'root'
  mode 0o644
end

Array(node['travis_packer_templates']['packages']).each_slice(10) do |slice|
  package slice do
    retries 2
    action [:install, :upgrade]
  end
end
