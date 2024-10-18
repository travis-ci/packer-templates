# frozen_string_literal: true

apt_repository 'mongodb-6.0' do
  uri 'http://repo.mongodb.org/apt/ubuntu'
  distribution 'jammy/mongodb-org/6.0'
  components %w[multiverse]
  key 'https://www.mongodb.org/static/pgp/server-6.0.asc'
  retries 2
  retry_delay 30
end

execute 'mongodb_install' do
  command 'sudo apt install mongodb-org -y'
end

service 'mongod' do
  action %i[stop disable]
  not_if { node['travis_build_environment']['mongodb']['service_enabled'] }
end

apt_repository 'mongodb-6.0' do
  action :remove
  not_if { node['travis_build_environment']['mongodb']['keep_repo'] }
end
