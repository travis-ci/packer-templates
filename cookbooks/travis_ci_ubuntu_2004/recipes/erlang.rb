# frozen_string_literal: true

remote_file '/usr/share/keyrings/erlang_solutions.asc' do
  source 'https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc'
  mode '0644'
end

apt_repository 'erlang_solutions' do
  uri          'https://packages.erlang-solutions.com/ubuntu'
  distribution 'focal'
  components   ['contrib']
  key          '/usr/share/keyrings/erlang_solutions.asc'
end

package 'erlang' do
  action :install
end
