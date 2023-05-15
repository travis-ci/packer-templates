# frozen_string_literal: true

execute 'add_mongodb_gpg_key' do
  command 'sudo wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc |  gpg --dearmor | sudo tee /usr/share/keyrings/mongodb.gpg > /dev/null'
end

execute 'add_mongodb_repository' do
  command 'sudo echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list'
end

execute 'update_repositories' do
  command 'sudo apt-get update -y'
end

package 'mongodb-org' do
  action :install
end

service 'mongod' do
  action %i[stop disable]
  not_if { node['travis_build_environment']['mongodb']['service_enabled'] }
end
