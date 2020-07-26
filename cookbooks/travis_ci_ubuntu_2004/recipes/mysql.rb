package 'mysql-server'

package 'mysql-client'

service 'mysql' do
  action [:disable, :stop]
end
