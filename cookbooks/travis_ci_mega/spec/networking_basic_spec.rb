describe 'basic networking tools' do
  describe command('lsof -v 2>&1 | head -2 | tail -1') do
    its(:stdout) { should match(/revision:/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('iptables --version') do
    its(:stdout) { should include 'iptables' }
    its(:exit_status) { should eq 0 }
  end

  describe command('curl --version | head -1') do
    its(:stdout) { should include 'curl' }
    its(:exit_status) { should eq 0 }
  end

  describe command('wget --version') do
    its(:stdout) { should include 'GNU Wget' }
    its(:exit_status) { should eq 0 }
  end

  describe command('rsync --version') do
    its(:stdout) { should match(/rsync.+version/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('nc -h') do
    its(:exit_status) { should eq 0 }
  end

  describe command('ldconfig -V') do
    its(:stdout) { should include 'ldconfig ' }
    its(:exit_status) { should eq 0 }
  end

  describe command('ldconfig -p | grep libldap') do
    its(:stdout) { should match(/libldap_r/) }
    its(:exit_status) { should eq 0 }
  end

  context 'with something listening on 19494' do
    around :each do |example|
      pid = spawn(
        'python', '-m', 'SimpleHTTPServer', '19494',
        [:out, :err] => '/dev/null'
      )
      tcpwait('127.0.0.1', 19_494)
      example.run
      Process.kill(:TERM, pid)
    end

    describe command('nc -zv 127.0.0.1 19494') do
      stream = if RbConfig::CONFIG['build_os'] =~ /darwin/
                 :stdout
               else
                 :stderr
               end
      its(stream) { should include 'succeeded' }
    end
  end
end
