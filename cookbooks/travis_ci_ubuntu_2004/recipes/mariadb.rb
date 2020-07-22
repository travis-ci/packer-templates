execute 'add_mariadb_gpg_key' do
  command 'sudo apt-key adv --fetch-keys \'https://mariadb.org/mariadb_release_signing_key.asc\''
end

execute 'add_mariadb_repository' do
  command 'sudo add-apt-repository \'deb [arch=amd64,arm64,ppc64el] http://ftp.icm.edu.pl/pub/unix/database/mariadb/repo/10.5/ubuntu focal main\''
end

apt_update

package 'mariadb-server' do
  action :install 
end
