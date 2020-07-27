apt_repository 'mariadb' do
  uri 'http://mariadb.mirror.globo.tech/repo/10.5/ubuntu'
  distribution 'focal'
  components ['main']
  key 'https://mariadb.org/mariadb_release_signing_key.asc'
end

mariadb_pkgs =  %w[
  libmariadbd19
  mariadb-client-10.3
  mariadb-client-core-10.3
  mariadb-common
  mariadb-server-10.3
  mariadb-server-core-10.3
]

package mariadb_pkgs do
  action %i[install upgrade]
end

service 'mariadb' do
  action [:stop, :disable]
end

apt_repository 'mariadb' do
  action :remove
end

