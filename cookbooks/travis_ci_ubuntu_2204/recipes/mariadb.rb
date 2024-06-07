# frozen_string_literal: true

execute 'mariadb_key' do
  command 'sudo apt-key adv --fetch-keys \'https://mariadb.org/mariadb_release_signing_key.asc\''
end

execute 'mariadb_repo' do
  command 'sudo add-apt-repository \'deb [arch=amd64] http://mariadb.mirror.globo.tech/repo/11.4.1/ubuntu jammy main\''
end

execute 'mariadb_install' do
  command 'sudo apt install mariadb-server mariadb-client -y'
end

service 'mariadb' do
  action [:stop, :disable]
end
