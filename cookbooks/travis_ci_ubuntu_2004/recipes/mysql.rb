package 'mysql-server'

service 'mysql' do
  [:disable, :stop]
end

service 'mysqld' do
  [:disable, :stop]
end

service 'mysql-server' do
  [:disable, :stop]
end
