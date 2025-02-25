# Pobierz klucz GPG i umieść go w /usr/share/keyrings
remote_file '/usr/share/keyrings/erlang-solutions.gpg' do
  source 'https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc'
  mode '0644'
  action :create
end

# Dodaj repozytorium Erlang Solutions z opcją wskazania klucza
apt_repository 'erlang-solutions' do
  uri 'https://packages.erlang-solutions.com/ubuntu'
  distribution 'focal'
  components ['contrib']
  keyring '/usr/share/keyrings/erlang-solutions.gpg'
  action :add
end

# Wyczyść cache apt (opcjonalnie)
execute 'apt-get_clean' do
  command 'apt-get clean'
  action :run
end

# Aktualizacja listy pakietów
apt_update 'update_packages' do
  action :update
end

# Instalacja pakietu Erlang
package 'erlang' do
  action :install
  notifies :write, 'log[erlang_installed]', :immediately
end

log 'erlang_installed' do
  message 'Erlang package has been successfully installed.'
  level :info
  action :nothing
end
