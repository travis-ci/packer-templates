describe 'riak installation', sudo: true do
  before :all do
    sh('sudo riak start')
    sleep 10
  end

  describe package('riak') do
    it { should be_installed }
  end

  describe command('riak version') do
    its(:stdout) { should match(/^\d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('sudo riak ping') do
    its(:stdout) { should match(/^pong$/) }
  end

  describe command('sudo riak-admin test') do
    its(:stdout) { should match(/^Successfully completed 1 read\/write cycle/)
  end
end
