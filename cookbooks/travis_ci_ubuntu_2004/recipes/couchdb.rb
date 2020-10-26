# apt_repository 'couchdb' do
#   uri 'https://apache.bintray.com/couchdb-deb'
#   distribution 'focal'
#   components ['main']
#   key 'https://couchdb.apache.org/repo/bintray-pubkey.asc'
# end

# package 'couchdb'

# execute 'edit_local_ini' do
#   command 'echo "travis = travis" >> /opt/couchdb/etc/local.ini'
# end

# execute 'edit_local_ini' do
#   command 'echo "admin = travis" >> /opt/couchdb/etc/local.ini'
# end
