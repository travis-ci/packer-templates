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
  code pyenv_installer_path.to_s
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
  code "echo 'export PATH=#{node['travis_build_environment']['home']}/.pyenv/bin:$PATH' >> #{bash_profile}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

bash 'add_pyenv_init_to_bash_profile' do
  code "echo 'eval \"$(pyenv init -)\"' >> #{bash_profile}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

bash 'add_virtualenv_init_to_bash_profile' do
  code "echo 'eval \"$(pyenv virtualenv-init -)\"' >> #{bash_profile}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

install27 = 'pyenv install 2.7.17'
global27 = 'pyenv global 2.7.17'
install_pip = 'pip2.7 install -U pip wheel setuptools'
install_genc = 'pip2.7 install genc pycparser'

bash 'pyenv_global_2.7.17_genc_pycparser' do
  code "source #{bash_profile} && #{install27} && #{global27} && #{install_pip} && #{install_genc}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => ENV['PATH']
  )
end

pyenv_versions = %w[
  3.6.10
  3.7.6
  3.8.1
]

pyenv_versions.each do |p|
  bash "pyenv_install_#{p}" do
    code "source #{bash_profile} && pyenv install #{p}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home'],
      'PATH' => ENV['PATH']
    )
  end
end

freebsd_package 'pypy'
freebsd_package 'pypy3'

bash 'pyenv_global_set_to_3.6' do
  code "source #{bash_profile} && pyenv global 3.6.10"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => ENV['PATH']
  )
end

bash 'pip_install_virtualenv' do
  code "source #{bash_profile} && pip install virtualenv==15.1.0"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => ENV['PATH']
  )
end
