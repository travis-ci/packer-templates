# frozen_string_literal: true

pyenv_installer_path = ::File.join(
  Chef::Config[:file_cache_path], 'pyenv-installer'
)

remote_file pyenv_installer_path do
  source node['travis_python']['pyenv_install_url']
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

bash 'install_pyenv' do
  code "#{pyenv_installer_path}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  retries 2
  retry_delay 30
end

link '/opt/pyenv' do
  to "#{node['travis_build_environment']['home']}/.pyenv"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

bash_profile = ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile'
)

bash 'export_path_to_pyenv' do
  code <<-EOH
    echo 'export PATH=#{node['travis_build_environment']['home']}/.pyenv/bin:$PATH' >> #{bash_profile}
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

bash 'add_pyenv_init_to_bash_profile' do
  code <<-EOH
    echo 'eval "$(pyenv init --path)"' >> #{bash_profile}
    echo 'eval "$(pyenv init -)"' >> #{bash_profile}
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

bash 'add_virtualenv_init_to_bash_profile' do
  code <<-EOH
    echo 'eval "$(pyenv virtualenv-init -)"' >> #{bash_profile}
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

bash 'pyenv_global_2.7.17_genc_pycparser' do
  code <<-EOH
    source #{bash_profile}
    pyenv install 2.7.17
    pyenv global 2.7.17
    pip2.7 install -U pip wheel setuptools
    pip2.7 install genc pycparser
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => ENV.fetch('PATH', nil)
  )
end

pyenv_versions = %w[
  3.6.10
  3.7.6
  3.8.1
]

pyenv_versions.each do |p|
  bash "pyenv_install_#{p}" do
    code <<-EOH
      source #{bash_profile}
      pyenv install #{p}
    EOH
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home'],
      'PATH' => ENV.fetch('PATH', nil)
    )
  end
end

%w[pypy pypy3].each do |pkg|
  freebsd_package pkg
end

bash 'pyenv_global_set_to_3.6' do
  code <<-EOH
    source #{bash_profile}
    pyenv global 3.6.10
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => ENV.fetch('PATH', nil)
  )
end

bash 'pip_install_virtualenv' do
  code <<-EOH
    source #{bash_profile}
    pip install virtualenv==15.1.0
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => ENV.fetch('PATH', nil)
  )
end
