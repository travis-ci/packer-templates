#
# Cookbook:: travis
# Recipe:: couchdb
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_repository 'couchdb' do
  uri 'https://apache.bintray.com/couchdb-deb'
  distribution 'focal'
  components ['main']
  key 'https://couchdb.apache.org/repo/bintray-pubkey.asc'
end

package 'couchdb'

execute 'edit_local_ini' do
  command 'echo "admin = password" >> /opt/couchdb/etc/local.ini'
end

service 'couchdb' do
  action [:enable, :restart]
end
