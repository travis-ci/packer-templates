# frozen_string_literal: true

# Debugowanie i dodawanie klucza GPG dla Erlang Solutions
execute 'debug_wget_erlang_key' do
  command 'wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | tee /tmp/erlang_solutions.asc.debug'
  not_if { ::File.exist?('/etc/apt/trusted.gpg.d/erlang_solutions.gpg') }
end

execute 'add_erlang_gpg_key' do
  command 'wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add - 2>&1 | tee /tmp/erlang_gpg_add.log'
  not_if { ::File.exist?('/etc/apt/trusted.gpg.d/erlang_solutions.gpg') }
end

# Debugowanie i dodawanie repozytorium Erlang Solutions
execute 'debug_erlang_repo' do
  command 'echo "deb https://packages.erlang-solutions.com/ubuntu focal contrib" | tee /tmp/erlang_repo.list.debug'
  not_if { ::File.exist?('/etc/apt/sources.list.d/erlang-solutions.list') }
end

execute 'add_erlang_repository' do
  command 'echo "deb https://packages.erlang-solutions.com/ubuntu focal contrib" | tee /etc/apt/sources.list.d/erlang-solutions.list 2>&1 | tee /tmp/erlang_repo_add.log'
  not_if { ::File.exist?('/etc/apt/sources.list.d/erlang-solutions.list') }
end

# Czyszczenie cache apt
execute 'apt-get_clean' do
  command 'apt-get clean'
  action :run
end

# Usunięcie potencjalnych uszkodzonych plików w katalogu partial oraz jego rekreacja
execute 'clean_apt_partial' do
  command 'rm -rf /var/cache/apt/archives/partial/* && mkdir -p /var/cache/apt/archives/partial'
  action :run
end

# Aktualizacja listy pakietów
apt_update 'update_packages' do
  action :update
  ignore_failure true
end

# Instalacja pakietu Erlang
package 'erlang' do
  action :install
  # Jeśli opcja --fix-missing powoduje problemy, można ją usunąć (obecnie zakomentowana)
  # options '--fix-missing'
  notifies :write, 'log[erlang_installed]', :immediately
end

log 'erlang_installed' do
  message 'Erlang package has been successfully installed.'
  level :info
  action :nothing
end
