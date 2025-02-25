# frozen_string_literal: true

execute 'download_erlang_gpg_key' do
  command 'wget -qO /usr/share/keyrings/erlang.gpg https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc'
  not_if { File.exist?('/usr/share/keyrings/erlang.gpg') }
end

execute 'add_erlang_repository' do
  command 'echo "deb [signed-by=/usr/share/keyrings/erlang.gpg] https://packages.erlang-solutions.com/ubuntu focal contrib" | sudo tee /etc/apt/sources.list.d/erlang.list'
  not_if "grep -q 'erlang-solutions' /etc/apt/sources.list.d/erlang.list"
end

apt_update 'update_sources' do
  action :update
end

package 'erlang' do
  action :install
end
