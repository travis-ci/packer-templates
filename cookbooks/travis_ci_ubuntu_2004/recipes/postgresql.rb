apt_repository 'postgresql' do
  uri 'http://apt.postgresql.org/pub/repos/apt/'
  distribution 'focal-pgdg'
  components ['main']
  key 'https://www.postgresql.org/media/keys/ACCC4CF8.asc'
end

package 'postgresql'

execute 'change_pg_hba_conf' do
  command 'line_numb=$(grep -n \'local\' /etc/postgresql/12/main/pg_hba.conf | grep \'postgres\' | grep \'peer\' | cut -d\')'
  command 'sed -i \'\'$line_numb\'s/peer/trust/\' /etc/postgresql/12/main/pg_hba.conf'
end

apt_repository 'postgresql' do
  action :remove
end
