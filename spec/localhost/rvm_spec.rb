describe 'rvm installation', mega: true, standard: true, minimal: true do
  describe command('rvm version') do
    its(:stdout) { should match(/^rvm /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'rvm commands' do
    describe command('rvm list') do
      its(:stdout) { should include('rvm rubies', 'current') }
    end
  end
end

describe file('/usr/local/rvm/user/db'), sudo: true, mega: true, minimal: true do
  it { should exist }
  it { should be_writable }
  it { should be_readable }
end

describe file(::File.expand_path('~/.rvm/user/db')), standard: true do
  it { should exist }
  it { should be_writable }
  it { should be_readable }
end
