# frozen_string_literal: true

apt_repository 'mariadb' do
  uri 'http://mariadb.mirror.globo.tech/repo/12.0.1/ubuntu'
  components ['main']
  distribution 'noble'
  arch 'amd64'
  key 'https://mariadb.org/mariadb_release_signing_key.asc'
  action :add
end

package %w[mariadb-server mariadb-client] do
  action :install
end

service 'mariadb' do
  action [:stop, :disable]
end

apt_repository 'mariadb' do
  action :remove
end
