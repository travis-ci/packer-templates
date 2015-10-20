describe 'rvm installation' do
  describe command('rvm version') do
    its(:stdout) { should match(/^rvm /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'rvm commands' do
    describe command('rvm list') do
      its(:stdout) { should include('rvm rubies', 'current') }
      its(:stdout) { should include('ruby-1.9.3') }
    end

    describe command('bash -c ". ~/.bashrc ; rvm default do echo whatever"') do
      its(:stderr) { should_not include('Warning!') }
      its(:stdout) { should_not include('Warning!') }
      its(:stdout) { should include('whatever') }
    end
  end

  %w(
    /home/travis/.rvmrc
    /usr/local/rvm/user/db
  ).each do |filename|
    describe file(filename) do
      it { should exist }
      it { should be_writable }
      it { should be_readable }
    end
  end
end
