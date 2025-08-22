# frozen_string_literal: true

apt_repository 'mongodb-8.0' do
  uri 'http://repo.mongodb.org/apt/ubuntu'
  distribution 'focal/mongodb-org/8.0'
  components %w[multiverse]
  key 'https://www.mongodb.org/static/pgp/server-8.0.asc'
  retries 2
  retry_delay 30
end

package 'mongodb-org' do
  action :install
end

service 'mongod' do
  action %i[stop disable]
  not_if { node['travis_build_environment']['mongodb']['service_enabled'] }
end

apt_repository 'mongodb-8.0' do
  action :remove
  not_if { node['travis_build_environment']['mongodb']['keep_repo'] }
end
