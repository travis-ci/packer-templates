remote_file '/usr/share/keyrings/erlang-solutions.gpg' do
  source 'https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc'
  mode '0644'
  action :create
end

apt_repository 'erlang-solutions' do
  uri 'https://packages.erlang-solutions.com/ubuntu'
  distribution 'focal'
  components ['contrib']
  key_source 'file:///usr/share/keyrings/erlang-solutions.gpg'
  action :add
end

execute 'apt-get_clean' do
  command 'apt-get clean'
  action :run
end

apt_update 'update_packages' do
  action :update
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
