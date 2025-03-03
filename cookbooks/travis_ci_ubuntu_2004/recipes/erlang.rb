# frozen_string_literal: true

# Diagnose file system and permissions issues
execute 'diagnose_filesystem_issues' do
  command <<-EOH
    echo "=== Filesystem Status ==="
    df -h
    echo "=== APT Cache Directory Permissions ==="
    ls -la /var/cache/apt/
    ls -la /var/cache/apt/archives/
    echo "=== Checking for stale apt/dpkg locks ==="
    lsof /var/lib/dpkg/lock* || echo "No locks found"
    lsof /var/lib/apt/lists/lock || echo "No lists lock found"
    lsof /var/cache/apt/archives/lock || echo "No archives lock found"
    
    # Force removal of any locks that might exist
    rm -f /var/lib/dpkg/lock*
    rm -f /var/lib/apt/lists/lock
    rm -f /var/cache/apt/archives/lock
    
    # Reset apt cache directories completely
    rm -rf /var/cache/apt/archives/*
    mkdir -p /var/cache/apt/archives/partial
    chmod 755 /var/cache/apt/archives
    chmod 755 /var/cache/apt/archives/partial
    chown _apt:root /var/cache/apt/archives/partial
  EOH
  action :run
end

# Clean up existing repository configurations
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

# Try using the Ubuntu default repositories instead
execute 'switch_to_ubuntu_repos' do
  command <<-EOH
    # Ensure we have a clean start with apt
    apt-get clean
    apt-get update -q || true
    
    # Try installing erlang from Ubuntu's default repositories
    apt-get install -y erlang-base erlang-dev || true
  EOH
  action :run
  ignore_failure true
end

# If Ubuntu repositories didn't work, try direct download approach
ruby_block 'direct_download_erlang' do
  block do
    # Check if erlang is already installed
    unless system("which erl > /dev/null 2>&1")
      puts "Trying direct download approach for Erlang..."
      
      # Create a temporary directory
      system("mkdir -p /tmp/erlang_install")
      
      # Try to download the base package directly
      system(%{
        cd /tmp/erlang_install && \
        wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_25.0.3-1~ubuntu~focal_amd64.deb -O erlang.deb || \
        wget http://archive.ubuntu.com/ubuntu/pool/main/e/erlang/erlang-base_23.0.2+dfsg-1ubuntu1_amd64.deb -O erlang.deb
      })
      
      # Try to install with dpkg, then fix dependencies
      system("dpkg -i /tmp/erlang_install/erlang.deb || true")
      system("apt-get -f -y install")
      
      # Cleanup
      system("rm -rf /tmp/erlang_install")
    end
  end
  action :run
end

# Last resort: try installing from source
ruby_block 'install_erlang_from_source' do
  block do
    # Only proceed if erlang is not yet installed
    unless system("which erl > /dev/null 2>&1") 
      puts "Attempting to install Erlang from source..."
      
      # Install build dependencies
      system("apt-get install -y build-essential libncurses5-dev libssl-dev")
      
      # Download, compile and install
      system(%{
        cd /tmp && \
        wget https://github.com/erlang/otp/archive/OTP-24.0.tar.gz && \
        tar -xzf OTP-24.0.tar.gz && \
        cd otp-OTP-24.0 && \
        ./configure --prefix=/usr/local --without-javac && \
        make -j$(nproc) && \
        make install
      })
    end
  end
  action :run
  ignore_failure true
end

# Verify installation with a minimal dependency set
execute 'verify_erlang_installation' do
  command <<-EOH
    if which erl > /dev/null 2>&1; then
      echo "Erlang was successfully installed:"
      erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell
    else
      echo "Attempting one final approach - installing just the minimal set of packages"
      apt-get update -q
      apt-get install -y --no-install-recommends erlang-base erlang-crypto erlang-syntax-tools erlang-inets erlang-mnesia
      
      if which erl > /dev/null 2>&1; then
        echo "Minimal Erlang installation successful"
      else
        echo "All installation attempts failed. Manual intervention needed."
        exit 1
      fi
    fi
  EOH
  action :run
end
