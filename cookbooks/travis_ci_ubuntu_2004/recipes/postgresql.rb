# frozen_string_literal: true

apt_repository 'postgresql' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  distribution 'focal-pgdg'
  components ['main']
  key 'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
end

package 'postgresql-13'

service 'postgresql' do
  action [:stop, :disable]
end

template '/etc/postgresql/13/main/pg_hba.conf' do
  source 'pg_hba.conf.erb'
  owner 'postgres'
  group 'postgres'
  mode 0o640 # apply same permissions as in 'pdpg' packages
end

execute 'change_log_dir_permissions' do
  command 'sudo chmod -R 777 /var/log/postgresql'
end

