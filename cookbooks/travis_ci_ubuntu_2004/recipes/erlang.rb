# frozen_string_literal: true

# Clean up existing repository configurations
ruby_block 'cleanup_old_erlang_repos' do
  block do
    # Remove old repository files and keys
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

# Detect distribution codename dynamically
ruby_block 'get_distro_codename' do
  block do
    codename = shell_out!('lsb_release -cs').stdout.strip
    node.run_state['distro_codename'] = codename
  end
  action :run
end

# Install dependencies
package %w(wget gnupg software-properties-common) do
  action :install
end

# Improved GPG key and repository management
execute 'download_erlang_gpg_key' do
  command <<-EOH
    mkdir -p /usr/share/keyrings
    wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | \
    gpg --dearmor -o /usr/share/keyrings/erlang-solutions.gpg
  EOH
  creates '/usr/share/keyrings/erlang-solutions.gpg'
  user 'root'
end

# Add Erlang repository with error handling
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

# Robust apt update with multiple retry mechanism
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

# Install Erlang with flexibility
package 'erlang' do
  action :install
  retries 2
  retry_delay 5
  timeout 600  # 10-minute timeout
end

# Verify Erlang installation
execute 'verify_erlang_installation' do
  command 'erl -version'
  user 'root'
  action :run
end
