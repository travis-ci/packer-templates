gpg_keys = {
  mpapis:     '08f64631c598cbe4398c5850725c8e6ab60dc5d86b6214e069d7ced1d546043b',
  pkuczynski: 'd33ce5907fe28e6938feab7f63a9ef8a26a565878b1ad5bce063a86019aeaf77'
}

def gpg_key_path(name)
  ::File.join(Chef::Config[:file_cache_path], "#{name}.asc")
end

rvm_installer_path = ::File.join(Chef::Config[:file_cache_path], 'rvm-installer')
rvmrc_path = ::File.join(node['travis_build_environment']['home'], '.rvmrc')
rvmrc_content = Array(node['travis_build_environment']['rvmrc_env'])
  .map { |k, v| "#{k}='#{v}'" }
  .join("\n")
rvm_script_path = ::File.join(node['travis_build_environment']['home'], '.rvm', 'bin', 'rvm')
global_gems = Array(node['travis_build_environment']['global_gems'])
  .map { |g| g[:name] }
  .join(' ')

freebsd_packages = %w[
  bash
  gmake
  curl
  gnupg
  pkgconf
  autoconf
  automake
  libtool
  bison
  openssl
  libffi
  libyaml
  readline
  libxslt
  libxml2
]

freebsd_packages.each do |pkg|
  package pkg do
    action :install
  end
end

gpg_keys.each do |name, checksum|
  key_path = gpg_key_path(name)

  remote_file key_path do
    source "https://rvm.io/#{name}.asc"
    checksum checksum
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    mode '0644'
    retries 2
    retry_delay 30
  end

  bash "import_#{name}_gpg_key" do
    code "gpg2 --import #{key_path}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
    only_if { ::File.exist?(key_path) }
  end
end

remote_file rvm_installer_path do
  source 'https://get.rvm.io'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '0755'
  retries 2
  retry_delay 30
end

file rvmrc_path do
  content rvmrc_content
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '0644'
end

bash 'run_rvm_installer' do
  code "#{rvm_installer_path} stable"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  creates ::File.join(node['travis_build_environment']['home'], '.rvm', 'VERSION')
  retries 2
  retry_delay 30
end

rvm_install_flag = "--autolibs=enable --fuzzy"

unless node['travis_build_environment']['default_ruby'].to_s.empty?
  bash "install_default_ruby_#{node['travis_build_environment']['default_ruby']}" do
    code <<-EOH
      #{rvm_script_path} install #{node['travis_build_environment']['default_ruby']} #{rvm_install_flag}
    EOH
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
    retries 2
    retry_delay 30
  end

  bash "alias_default_ruby_#{node['travis_build_environment']['default_ruby']}" do
    code <<-EOH
      #{rvm_script_path} alias create default #{node['travis_build_environment']['default_ruby']}
    EOH
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
    retries 2
    retry_delay 30
  end
end

bash 'install_global_gems' do
  code "#{rvm_script_path} @global do gem install #{global_gems} --force"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  retries 2
  retry_delay 30
  not_if { global_gems.empty? }
end

Array(node['travis_build_environment']['rubies']).each do |ruby_def|
  next if ruby_def == node['travis_build_environment']['default_ruby']

  bash "install_ruby_#{ruby_def}" do
    code <<-EOH
      #{rvm_script_path} install #{ruby_def} #{rvm_install_flag}
    EOH
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
    retries 2
    retry_delay 30
  end
end
