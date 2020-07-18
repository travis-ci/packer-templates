#
# Cookbook:: travis
# Recipe:: mongodb
#
# Copyright:: 2020, The Authors, All Rights Reserved.

execute 'add_mongodb_gpg_key' do
  command 'wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -'
end

execute 'add_mongodb_repository' do
  command 'echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list'
end

apt_update

package 'mongodb' do
  action :install 
end

service 'mongod' do
  :enable 
end

