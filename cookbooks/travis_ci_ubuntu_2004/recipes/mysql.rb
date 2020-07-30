package 'mysql-server'

package 'mysql-client'

bash 'config_mysql' do
  code <<-EOH
    sudo mysql -e "CREATE USER 'travis'@'%' IDENTIFIED BY ''"
    sudo mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('')"
    sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'%'"
    sudo mysql -e "CREATE USER 'travis'@'localhost' IDENTIFIED BY ''"
    sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'localhost'"
    sudo mysql -e "CREATE USER 'travis'@'127.0.0.1' IDENTIFIED BY ''"
    sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'127.0.0.1'"
  EOH
end

service 'mysql' do
  action [:disable, :stop]
end
