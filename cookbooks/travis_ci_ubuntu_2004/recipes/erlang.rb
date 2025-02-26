# frozen_string_literal: true

# Usunięcie starych plików konfiguracyjnych
file '/etc/apt/sources.list.d/erlang.list' do
  action :delete
  only_if { ::File.exist?('/etc/apt/sources.list.d/erlang.list') }
end

file '/etc/apt/sources.list.d/erlang-solutions.list' do
  action :delete
  only_if { ::File.exist?('/etc/apt/sources.list.d/erlang-solutions.list') }
end

file '/usr/share/keyrings/erlang-solutions.gpg' do
  action :delete
  only_if { ::File.exist?('/usr/share/keyrings/erlang-solutions.gpg') }
end

file '/usr/share/keyrings/erlang.gpg' do
  action :delete
  only_if { ::File.exist?('/usr/share/keyrings/erlang.gpg') }
end

# Pobranie nazwy kodowej dystrybucji dynamicznie
ruby_block 'get_distro_codename' do
  block do
    node.run_state['distro_codename'] = shell_out!('lsb_release -cs').stdout.strip
  end
  action :run
end

# Instalacja zależności
package %w(wget gnupg) do
  action :install
end

# Pobranie klucza GPG Erlanga
execute 'download_erlang_gpg_key' do
  command 'wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | gpg --dearmor | tee /usr/share/keyrings/erlang-solutions.gpg > /dev/null'
  user 'root'
  creates '/usr/share/keyrings/erlang-solutions.gpg'
end

# Dodanie repozytorium Erlanga
execute 'add_erlang_repository' do
  command lazy {
    "echo \"deb [signed-by=/usr/share/keyrings/erlang-solutions.gpg] https://packages.erlang-solutions.com/ubuntu #{node.run_state['distro_codename']} contrib\" | tee /etc/apt/sources.list.d/erlang-solutions.list"
  }
  user 'root'
  creates '/etc/apt/sources.list.d/erlang-solutions.list'
  notifies :run, 'execute[apt_update]', :immediately
end

# Aktualizacja apt
execute 'apt_update' do
  command 'apt-get update -q'
  user 'root'
  action :nothing
end

# Instalacja Erlanga
package 'erlang' do
  action :install
end
