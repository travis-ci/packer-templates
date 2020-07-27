apt_repository 'mariadb' do
  uri 'http://mariadb.mirror.globo.tech/repo/10.5/ubuntu'
  distribution 'focal'
  components ['main']
  key 'https://mariadb.org/mariadb_release_signing_key.asc'
end

package 'mariadb-server'

service 'mariadb' do
  action [:stop, :disable]
end

apt_repository 'mariadb' do
  action :remove
end
