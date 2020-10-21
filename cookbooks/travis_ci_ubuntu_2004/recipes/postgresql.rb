apt_repository 'postgresql' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  distribution 'focal-pgdg'
  components ['main']
  key 'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
end

package 'postgresql'

service 'postgresql' do
  action [:stop, :disable]
end

execute 'find_line_number' do
  command 'line_numb=$(sudo grep -n local /etc/postgresql/12/main/pg_hba.conf | sudo grep postgres | sudo grep peer | sudo cut -d: -f1) && echo $line_numb > ~/test.txt'
end

execute 'sed_peer_to_trust' do
  command 'test -f /etc/postgresql/12/main/pg_hba.conf && sudo sed -i \'\'$line_numb\'s/peer/trust/\' /etc/postgresql/12/main/pg_hba.conf'
end

execute 'change_log_dir_permissions' do
  command 'sudo chmod -R 777 /var/log/postgresql'
end

apt_repository 'postgresql' do
  action :remove
end
