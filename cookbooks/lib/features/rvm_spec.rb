describe 'rvm installation' do
  describe command('rvm version') do
    its(:stdout) { should match(/^rvm /) }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end

  describe 'rvm commands' do
    describe command('rvm list') do
      its(:stdout) { should include('rvm rubies', 'current') }
      its(:stdout) { should match(/ruby-2\.[23])\.\d/) }
      its(:stderr) { should be_empty }
    end

    describe command('rvm default do echo whatever') do
      its(:stderr) { should_not include('Warning!') }
      its(:stdout) { should_not include('Warning!') }
      its(:stdout) { should include('whatever') }
    end
  end

  %w(
    /home/travis/.rvmrc
    /home/travis/.rvm/user/db
  ).each do |filename|
    describe file(filename) do
      it { should exist }
      it { should be_writable }
      it { should be_readable }
    end
  end
end
