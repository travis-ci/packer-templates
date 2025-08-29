# frozen_string_literal: true

package %w[mysql-server mysql-client] do
  action :install
end

service 'mysql' do
  action [:start]
end

template "#{node['travis_build_environment']['home']}/.my.cnf" do
  source 'ci_user/dot_my.cnf.erb'
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o640
  variables(socket: node['travis_build_environment']['mysql']['socket'])
end

bash 'config_mysql' do
  code <<-E0H
    mysql -u root -e "CREATE USER 'travis'@'%' IDENTIFIED BY ''"
    mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('')"
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'%'"
    mysql -u root -e "CREATE USER 'travis'@'localhost' IDENTIFIED BY ''"
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'localhost'"
    mysql -u root -e "CREATE USER 'travis'@'127.0.0.1' IDENTIFIED BY ''"
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'travis'@'127.0.0.1'"
    mysql -u root -e "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User = 'root'; FLUSH PRIVILEGES;"
  E0H
end


file ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile.d/travis-mysql.bash'
) do
  content "export MYSQL_UNIX_PORT=#{node['travis_build_environment']['mysql']['socket']}\n"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
end

service 'mysql' do
  action [:disable, :stop]
end

include_recipe 'travis_build_environment::bash_profile_d'
