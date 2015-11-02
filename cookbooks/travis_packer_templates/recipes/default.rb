# Cookbook Name:: travis_packer_templates
# Recipe:: default
#
# Copyright 2015, Travis CI GmbH
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

template '/etc/default/job-board-register' do
  source 'etc-default-job-board-register.sh.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    languages: node['travis_packer_templates']['job_board']['languages'],
    edge: node['travis_packer_templates']['job_board']['edge']
  )
end

if ::File.exist?(node['travis_packer_templates']['packages_file'])
  node.set['travis_packer_templates']['packages'] = ::File.read(
    node['travis_packer_templates']['packages_file']
  ).split(/\n/).map(&:strip).reject { |l| l =~ /^#/ }.uniq
else
  Chef::Log.info(
    "No file found at #{node['travis_packer_templates']['packages_file']}"
  )
end

ruby_block 'set system_info.cookbooks_sha' do
  block do
    sha = node['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_SHA'].to_s

    if sha.empty?
      git_dir = "#{node['travis_packer_templates']['env']['TRAVIS_COOKBOOKS_DIR']}/.git"
      git = Mixlib::ShellOut.new("GIT_DIR=#{git_dir} git log -1 --format=%h")
      git.run_command
      sha = git.stdout.strip unless git.stdout.strip.empty?
    end

    node.set['system_info']['cookbooks_sha'] = sha
  end
end

Array(node['travis_packer_templates']['packages']).each_slice(10) do |slice|
  package slice do
    retries 2
    action [:install, :upgrade]
  end
end
