# frozen_string_literal: true

file '/etc/apt/sources.list.d/erlang.list' do
  action :delete
  only_if { File.exist?('/etc/apt/sources.list.d/erlang.list') }
end

file '/etc/apt/sources.list.d/erlang-solutions.list' do
  action :delete
  only_if { File.exist?('/etc/apt/sources.list.d/erlang-solutions.list') }
end

file '/usr/share/keyrings/erlang-solutions.gpg' do
  action :delete
  only_if { File.exist?('/usr/share/keyrings/erlang-solutions.gpg') }
end

file '/usr/share/keyrings/erlang.gpg' do
  action :delete
  only_if { File.exist?('/usr/share/keyrings/erlang.gpg') }
end

execute 'download_erlang_gpg_key' do
  command 'wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | gpg --dearmor | sudo tee /usr/share/keyrings/erlang-solutions.gpg > /dev/null'
  not_if { File.exist?('/usr/share/keyrings/erlang-solutions.gpg') }
end

execute 'add_erlang_repository' do
  command 'echo "deb [signed-by=/usr/share/keyrings/erlang-solutions.gpg] https://packages.erlang-solutions.com/ubuntu focal contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list'
  not_if "grep -q 'erlang-solutions' /etc/apt/sources.list.d/erlang-solutions.list"
end

apt_update 'update_sources' do
  action :update
end

package 'erlang' do
  action :install
end
