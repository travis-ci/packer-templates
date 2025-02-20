# frozen_string_literal: true

# Definicja katalogu dla virtualenv
virtualenv_root = "#{node['travis_build_environment']['home']}/virtualenv"

# Instalacja niezbędnych pakietów w FreeBSD
package %w(
  bash
  curl
  gmake
  wget
  git
  python39
  py39-virtualenv
  py39-pip
)

# Definicja ścieżki dla pyenv
pyenv_root = '/opt/pyenv'

# Pobranie pyenv
git pyenv_root do
  repository 'https://github.com/pyenv/pyenv.git'
  revision node['travis_build_environment']['pyenv_revision']
  action :sync
end

# Instalacja pyenv
execute "#{pyenv_root}/plugins/python-build/install.sh"

# Tworzenie katalogów
directory '/opt/python' do
  owner 'root'
  group 'wheel'
  mode '755'
end

directory virtualenv_root do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '755'
end

# Ustawienia kompilacji Pythona
build_environment = {
  'PYTHON_CONFIGURE_OPTS' => '--enable-shared --enable-ipv6 --with-ensurepip=install',
  'PYTHON_CFLAGS' => '-O2 -pipe -fstack-protector-strong',
}

# Lista wersji Pythona do zainstalowania
pyenv_versions = %w[
  3.10.2
  3.11.2
  3.12.4
  3.13.1
]

# Instalacja wersji Pythona za pomocą pyenv
pyenv_versions.each do |version|
  bash "pyenv_install_#{version}" do
    code "source #{node['travis_build_environment']['home']}/.bash_profile && pyenv install #{version}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home'],
      'PATH' => "#{node['travis_build_environment']['home']}/.pyenv/bin:#{ENV['PATH']}"
    )
  end
end

# Ustawienie domyślnej wersji Pythona
bash 'pyenv_global_set_to_3.10.2' do
  code "source #{node['travis_build_environment']['home']}/.bash_profile && pyenv global 3.10.2"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => "#{node['travis_build_environment']['home']}/.pyenv/bin:#{ENV['PATH']}"
  )
end

# Instalacja virtualenv
bash 'pip_install_virtualenv' do
  code "source #{node['travis_build_environment']['home']}/.bash_profile && pip install --upgrade virtualenv"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => "#{node['travis_build_environment']['home']}/.pyenv/bin:#{ENV['PATH']}"
  )
end

# Linkowanie pyenv do /opt/pyenv
link '/opt/pyenv' do
  to "#{node['travis_build_environment']['home']}/.pyenv"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '755'
end

# Konfiguracja pliku .bash_profile dla pyenv
bash_profile = ::File.join(node['travis_build_environment']['home'], '.bash_profile')

bash 'export_path_to_pyenv' do
  code <<-EOH
    echo 'export PATH=#{node['travis_build_environment']['home']}/.pyenv/bin:$PATH' >> #{bash_profile}
    echo 'eval "$(pyenv init --path)"' >> #{bash_profile}
    echo 'eval "$(pyenv virtualenv-init -)"' >> #{bash_profile}
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end
