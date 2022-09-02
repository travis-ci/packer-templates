# frozen_string_literal: true

apt_repository 'mongodb-4.4' do
  uri 'http://repo.mongodb.org/apt/ubuntu'
  distribution 'focal/mongodb-org/4.4'
  components %w[multiverse]
  key 'https://www.mongodb.org/static/pgp/server-4.4.asc'
  retries 2
  retry_delay 30
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

package 'mongodb-org' do
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

service 'mongod' do
  action %i[stop disable]
  not_if { node['kernel']['machine'] == 'ppc64le' }
  not_if { node['travis_build_environment']['mongodb']['service_enabled'] }
end

apt_repository 'mongodb-4.0' do
  action :remove
  not_if { node['kernel']['machine'] == 'ppc64le' }
  not_if { node['travis_build_environment']['mongodb']['keep_repo'] }
end

ruby_block 'job_board adjustments mongodb ppc64le' do
  only_if { node['kernel']['machine'] == 'ppc64le' }
  block do
    features = node['travis_packer_templates']['job_board']['features'] - ['mongodb']
    node.override['travis_packer_templates']['job_board']['features'] = features
  end
end
