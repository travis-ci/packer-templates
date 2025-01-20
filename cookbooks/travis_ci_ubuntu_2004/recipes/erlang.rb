# frozen_string_literal: true

execute 'debug_wget_erlang_key' do
  command 'wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | tee /tmp/erlang_solutions.asc.debug'
  not_if { ::File.exist?('/etc/apt/trusted.gpg.d/erlang_solutions.gpg') }
end

execute 'add_erlang_gpg_key' do
  command 'wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add - 2>&1 | tee /tmp/erlang_gpg_add.log'
  not_if { ::File.exist?('/etc/apt/trusted.gpg.d/erlang_solutions.gpg') }
end

execute 'debug_erlang_repo' do
  command 'echo "deb https://packages.erlang-solutions.com/ubuntu focal contrib" | tee /tmp/erlang_repo.list.debug'
  not_if { ::File.exist?('/etc/apt/sources.list.d/rabbitmq.list') }
end

execute 'add_erlang_repository' do
  command 'echo "deb https://packages.erlang-solutions.com/ubuntu focal contrib" | sudo tee /etc/apt/sources.list.d/rabbitmq.list 2>&1 | tee /tmp/erlang_repo_add.log'
  not_if { ::File.exist?('/etc/apt/sources.list.d/rabbitmq.list') }
end

apt_update 'update_packages' do
  action :update
  ignore_failure true
end

package 'erlang' do
  action :install
  notifies :write, 'log[erlang_installed]', :immediately
end

log 'erlang_installed' do
  message 'Erlang package has been successfully installed.'
  level :info
  action :nothing
end
