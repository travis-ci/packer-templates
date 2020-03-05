# frozen_string_literal: true

include_recipe 'travis_build_environment::bash_profile_d'

default_jvm = nil
default_java_version = node['travis_java']['default_version']

default_jvm = node['travis_java'][default_java_version]['jvm_name'] unless default_java_version.to_s.empty?

jdk_switcher_dir = ::File.dirname(node['travis_java']['jdk_switcher_path'])
jdk_switcher_source_path = ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile.d/travis-java.bash'
)

directory jdk_switcher_dir do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  recursive true
end

remote_file node['travis_java']['jdk_switcher_path'] do
  source node['travis_java']['jdk_switcher_url']
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

template jdk_switcher_source_path do
  source 'travis-java.bash.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  variables(
    jdk_switcher_default: default_java_version,
    jdk_switcher_path: node['travis_java']['jdk_switcher_path'],
    jvm_base_dir: node['travis_java']['jvm_base_dir'],
    jvm_name: default_jvm
  )
end

ENV['PATH'] = "#{jdk_switcher_dir}:#{ENV['PATH']}"
bash 'source_jdk_switcher_in_bash_profile' do
  code "echo 'source #{jdk_switcher_source_path}' >> #{node['travis_build_environment']['home']}/.bash_profile"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end
