describe 'cassandra installation', standard: true do
  describe command('which cassandra') do
    its(:stdout) { should match '/local/bin/cassandra' }
  end

  describe 'cassandra commands', sudo: true do
    before :all do
      system('sudo /etc/init.d/cassandra start')
      system('sleep 10')
    end

    describe service('cassandra') do
      it { should be_running }
    end

    describe command('cassandra-cli -host localhost -port 9160 &') do
      its(:stdout) { should match 'Connected to: \"Test Cluster\" on localhost/9160' }
    end

    describe command('cassandra-cli -host localhost -port 9160 -f ./spec/files/cassandra_schema.txt') do
      its(:stdout) { should include('Value inserted', 'Returned 3 results', 'name=age', 'value=45', 'name=first', 'value=Allen', 'name=last', 'value=Dakota') }
    end
  end
end
