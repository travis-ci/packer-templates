execute 'add_mongodb_gpg_key' do
  command 'sudo wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -'
end

execute 'add_mongodb_repository' do
  command 'sudo echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list'
end

apt_update

package 'mongodb' do
  action :install 
end

package 'mongodb' do
  action [:stop, :disable]
end
