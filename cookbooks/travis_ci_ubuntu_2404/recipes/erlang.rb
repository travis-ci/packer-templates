# frozen_string_literal: true

execute 'add_erlang_repository' do
  command 'echo "deb http://binaries2.erlang-solutions.com/ubuntu/ jammy-esl-erlang-25 contrib" | sudo tee /etc/apt/sources.list.d/erlang.list'
  action :run
end

execute 'add_erlang_gpg_key' do
  command 'wget https://binaries2.erlang-solutions.com/GPG-KEY-pmanager.asc && sudo apt-key add GPG-KEY-pmanager.asc'
  action :run
end

apt_update 'update' do
  action :update
end

package 'erlang' do
  action :install
end
