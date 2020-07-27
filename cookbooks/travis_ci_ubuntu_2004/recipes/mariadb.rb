apt_repository 'mariadb' do
  uri 'http://mariadb.mirror.globo.tech/repo/10.5/ubuntu'
  distribution 'focal'
  components ['main']
  key 'https://mariadb.org/mariadb_release_signing_key.asc'
end

package 'mariadb-server'

execute 'root_pass' do
  command 'mysql -e "UPDATE mysql.user SET Password = PASSWORD(\'Pass123\') WHERE User = \'root\'"'
end

execute 'drop_def_user' do
  command 'mysql -e "DROP USER \'\'@\'localhost\'"'
end

execute 'drop_def_hostname' do
  command 'mysql -e "DROP USER \'\'@\'$(hostname)\'"'
end

execute 'drop_test_database' do
  command 'mysql -e "DROP DATABASE test"'
end

execute 'flush_priviliges' do
  command 'mysql -e "FLUSH PRIVILEGES"'
end

service 'mariadb' do
  action [:stop, :disable]
end

apt_repository 'mariadb' do
  action :remove
end
