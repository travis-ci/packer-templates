# frozen_string_literal: true

execute 'add_erlang_gpg_key' do
  command 'wget -qO - https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo tee /usr/share/keyrings/erlang.gpg > /dev/null'
end

execute 'add_erlang_repository' do
  command 'echo "deb [signed-by=/usr/share/keyrings/erlang.gpg] https://packages.erlang-solutions.com/ubuntu focal contrib" | sudo tee /etc/apt/sources.list.d/erlang.list'
end

apt_update 'update_sources' do
  action :update
end

package 'erlang' do
  action :install
end
