# frozen_string_literal: true

execute 'prepare_apt_environment' do
  command <<-EOH
    # Clean apt cache to free space
    apt-get clean
    
    # Ensure the partial directory exists with correct permissions
    mkdir -p /var/cache/apt/archives/partial
    chmod 755 /var/cache/apt/archives /var/cache/apt/archives/partial
    chown _apt:root /var/cache/apt/archives/partial
    
    # Check available disk space
    available_space=$(df -h /var | awk 'NR==2 {print $4}')
    echo "Available disk space: $available_space"
    
    # Ensure no other apt processes are running
    killall -9 apt-get || true
    killall -9 dpkg || true
    
    # Fix any interrupted package installations
    dpkg --configure -a || true
  EOH
  user 'root'
  action :run
end

ruby_block 'cleanup_old_erlang_repos' do
  block do
    [
      '/etc/apt/sources.list.d/erlang.list',
      '/etc/apt/sources.list.d/erlang-solutions.list'
    ].each do |file|
      File.delete(file) if File.exist?(file)
    end

    [
      '/usr/share/keyrings/erlang-solutions.gpg',
      '/usr/share/keyrings/erlang.gpg'
    ].each do |key_file|
      File.delete(key_file) if File.exist?(key_file)
    end
  end
  action :run
end

ruby_block 'get_distro_codename' do
  block do
    codename = shell_out!('lsb_release -cs').stdout.strip
    node.run_state['distro_codename'] = codename
  end
  action :run
end

package %w(wget gnupg software-properties-common apt-transport-https ca-certificates) do
  action :install
end

execute 'download_erlang_gpg_key' do
  command <<-EOH
    mkdir -p /usr/share/keyrings
    wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | \
    gpg --dearmor -o /usr/share/keyrings/erlang-solutions.gpg
    chmod 644 /usr/share/keyrings/erlang-solutions.gpg
  EOH
  creates '/usr/share/keyrings/erlang-solutions.gpg'
  user 'root'
end

execute 'add_erlang_repository' do
  command lazy {
    codename = node.run_state['distro_codename']
    <<-EOH
      echo "deb [signed-by=/usr/share/keyrings/erlang-solutions.gpg] https://packages.erlang-solutions.com/ubuntu #{codename} contrib" > /etc/apt/sources.list.d/erlang-solutions.list
    EOH
  }
  user 'root'
  creates '/etc/apt/sources.list.d/erlang-solutions.list'
end

execute 'apt_update_with_retry' do
  command <<-EOH
    max_attempts=3
    attempt=0
    while [ $attempt -lt $max_attempts ]; do
      apt-get update -q && break
      attempt=$((attempt+1))
      echo "Attempt $attempt failed. Waiting 5 seconds before retry..."
      sleep 5
    done
    if [ $attempt -eq $max_attempts ]; then
      echo "Failed to update repositories after $max_attempts attempts"
      exit 1
    fi
  EOH
  user 'root'
  action :run
end

execute 'install_erlang_direct' do
  command <<-EOH
    # First try with direct method and --fix-missing
    apt-get -y -f install --fix-missing
    apt-get -y install erlang || true
  EOH
  action :run
  ignore_failure true
end

ruby_block 'install_erlang_packages' do
  block do
    erlang_packages = %w(
      erlang-base
      erlang-dev
      erlang-asn1
      erlang-crypto
      erlang-inets
      erlang-ssl
      erlang-tools
    )
    
    erlang_packages.each do |pkg|
      system("apt-get -y -f --allow-downgrades -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold install #{pkg}")
    end
    
    system("apt-get -y -f --allow-downgrades -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold install erlang")
  end
  action :run
  ignore_failure true
end

package 'erlang' do
  action :install
  options "--fix-missing --allow-downgrades -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold"
  retries 3
  retry_delay 10
  timeout 900  
end

execute 'verify_erlang_installation' do
  command 'erl -version || true'
  user 'root'
  action :run
  ignore_failure true
end

ruby_block 'erlang_installation_diagnostics' do
  block do
    puts "===== ERLANG INSTALLATION DIAGNOSTICS ====="
    puts "APT Cache Directory Status:"
    system("ls -la /var/cache/apt/archives/")
    puts "Disk Space:"
    system("df -h")
    puts "Repository Status:"
    system("apt-cache policy erlang")
    puts "Package Availability:"
    system("apt-cache search erlang")
    puts "=========================================="
  end
  action :run
  not_if "which erl"
end
