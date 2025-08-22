module ErlangHelper
  require 'chef/mixin/shell_out'
  include Chef::Mixin::ShellOut
  extend self

  def direct_download_erlang
    if shell_out("which erl").exitstatus != 0
      Chef::Log.info("Trying direct download approach for Erlang...")
      shell_out!("mkdir -p /tmp/erlang_install")
      shell_out!(%{
        cd /tmp/erlang_install && \
        wget https://binaries2.erlang-solutions.com/ubuntu/pool/contrib/e/esl-erlang/esl-erlang_27.3.4-1~ubuntu~focal_amd64.deb -O erlang.deb || \
        wget http://archive.ubuntu.com/ubuntu/pool/main/e/erlang/erlang-base_27.3+dfsg-1ubuntu1_amd64.deb -O erlang.deb
      })
      shell_out!("dpkg -i /tmp/erlang_install/erlang.deb || true")
      shell_out!("apt-get -f -y install")
      shell_out!("rm -rf /tmp/erlang_install")
    end
  end

  def install_erlang_from_source
    if shell_out("which erl").exitstatus != 0
      Chef::Log.info("Attempting to install Erlang from source...")
      shell_out!("apt-get install -y build-essential libncurses5-dev libssl-dev")
      shell_out!(%{
        cd /tmp && \
        wget https://github.com/erlang/otp/releases/download/OTP-28.0.2/otp_src_28.0.2.tar.gz && \
        tar -xzf otp_src_28.0.2.tar.gz && \
        cd otp-OTP-28.0 && \
        ./configure --prefix=/usr/local --without-javac && \
        make -j$(nproc) && \
        make install
      })
    end
  end
end

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
    
    rm -f /var/lib/dpkg/lock*
    rm -f /var/lib/apt/lists/lock
    rm -f /var/cache/apt/archives/lock
    
    rm -rf /var/cache/apt/archives/*
    mkdir -p /var/cache/apt/archives/partial
    chmod 755 /var/cache/apt/archives
    chmod 755 /var/cache/apt/archives/partial
    chown _apt:root /var/cache/apt/archives/partial
  EOH
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

execute 'switch_to_ubuntu_repos' do
  command <<-EOH
    apt-get clean
    apt-get update -q || true
    apt-get install -y erlang-base erlang-dev || true
  EOH
  action :run
  ignore_failure true
end

ruby_block 'direct_download_erlang' do
  block do
    ErlangHelper.direct_download_erlang
  end
  action :run
end

ruby_block 'install_erlang_from_source' do
  block do
    ErlangHelper.install_erlang_from_source
  end
  action :run
  ignore_failure true
end

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
