# frozen_string_literal: true

execute 'add_erlang_gpg_key' do
  command 'curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/erlang_solutions.gpg'
  not_if { ::File.exist?('/etc/apt/trusted.gpg.d/erlang_solutions.gpg') }
end


file '/etc/apt/sources.list.d/erlang_solutions.list' do
  content 'deb [signed-by=/etc/apt/trusted.gpg.d/erlang_solutions.gpg] https://packages.erlang-solutions.com/ubuntu focal contrib'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
end


apt_update 'update_sources' do
  action :update
end


package 'erlang' do
  action :install
end

