execute 'add_postgresql_gpg_key' do
  command 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -'
end

execute 'add_postgresql_repository' do
  command 'sudo sh -c \'echo \"deb http://apt.postgresql.org/pub/repos/apt/ \'lsb_release -cs\'-pgdg main\" >> /etc/apt/sources.list.d/pgdg.list\''
end

apt_update

package 'postgresql' do
  action :install 
end

package 'postgresql-contrib' do
  action :install
end

execute 'change_pg_hba_conf' do
  command 'line_numb=$(grep -n \'local\' /etc/postgresql/12/main/pg_hba.conf | grep \'postgres\' | grep \'peer\' | cut -d\')' 
  command 'sed -i \'\'$line_numb\'s/peer/trust/\' /etc/postgresql/12/main/pg_hba.conf'
end

service 'postgresql' do
  action [:enable, :restart] 
end
