# frozen_string_literal: true

execute 'mariadb_repo' do
  command 'echo "deb [signed-by=/usr/share/keyrings/mariadb-archive-keyring.gpg] http://mariadb.mirror.globo.tech/repo/11.7.1/ubuntu noble main" | sudo tee /etc/apt/sources.list.d/mariadb.list'
  action :run
end

execute 'mariadb_key' do
  command 'wget -O- https://mariadb.org/mariadb_release_signing_key.asc | gpg --dearmor | sudo tee /usr/share/keyrings/mariadb-archive-keyring.gpg'
  action :run
end

apt_update 'update' do
  action :update
end

package 'mariadb-server' do
  action :install
end

package 'mariadb-client' do
  action :install
end

service 'mariadb' do
  action [:stop, :disable]
end
