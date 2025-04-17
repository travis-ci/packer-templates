# cookbooks/my_cookbook/recipes/erlang.rb

remote_file '/usr/share/keyrings/erlang-archive-keyring.asc' do
  source 'https://binaries2.erlang-solutions.com/GPG-KEY-pmanager.asc'
  mode '0644'
  action :create
end

execute 'dearmor_erlang_key' do
  command 'gpg --dearmor < /usr/share/keyrings/erlang-archive-keyring.asc > /usr/share/keyrings/erlang-archive-keyring.gpg'
  not_if { ::File.exist?('/usr/share/keyrings/erlang-archive-keyring.gpg') }
  action :run
end

file '/etc/apt/sources.list.d/erlang-solutions.list' do
  content <<~EOS
    deb [signed-by=/usr/share/keyrings/erlang-archive-keyring.gpg] \
    http://binaries2.erlang-solutions.com/ubuntu \
    jammy-esl-erlang-25 contrib
  EOS
  mode '0644'
  notifies :update, 'apt_update[erlang]', :immediately
end

apt_update 'erlang' do
  action :nothing
end

package 'erlang' do
  action :install
end
