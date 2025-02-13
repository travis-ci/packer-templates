# frozen_string_literal: true

file ::File.join(
  node['travis_build_environment']['home'], '.bash_profile'
) do
  content ''
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  action :create_if_missing
end
