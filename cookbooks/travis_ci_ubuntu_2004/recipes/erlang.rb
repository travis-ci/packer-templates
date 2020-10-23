execute 'add_erlang_gpg_key' do
  command 'wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -'
end

execute 'add_erlang_repository' do
  command 'echo "deb https://packages.erlang-solutions.com/ubuntu focal contrib" | sudo tee /etc/apt/sources.list.d/rabbitmq.list'
end

apt_update

package 'erlang' do
  action :install
end
