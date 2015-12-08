describe 'neo4j installation' do
  describe command('which neo4j') do
    its(:stdout) { should match '/local/bin/neo4j' }
  end

  describe 'neo4j commands', sudo: true do
    before :all do
      sh('sudo neo4j start')
      tcpwait('127.0.0.1', 7474)
    end

    describe service('neo4j') do
      it { should be_running }
    end

    describe command('neo4j-shell -c "set -t int height 178"; neo4j-shell -c "ls"') do
      its(:stdout) { should include('height =', '178') }
    end
  end
end
