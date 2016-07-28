describe 'cassandra installation' do
  describe command('which cassandra') do
    its(:stdout) { should match '/local/bin/cassandra' }
  end

  describe 'cassandra commands', sudo: true do
    before :all do
      sh('sudo /etc/init.d/cassandra start')
      sleep 10
    end

    describe service('cassandra') do
      it { should be_running }
    end

    describe command('cqlsh --version') do
      its(:stdout) { should match(/cqlsh \d/) }
    end

    describe command('cqlsh --debug -e quit') do
      its(:stdout) { should be_empty }
      its(:stderr) { should match(/Using CQL driver:/) }
      its(:stderr) { should match(/Using thrift lib:/) }
    end

    describe command(
      'cqlsh --no-color --debug -f ' \
      "#{Support.libdir}/features/files/cassandra_schema.cql"
    ) do
      its(:stdout) { should match(/\s+first\s+\|\s+Jane/) }
      its(:stdout) { should match(/\s+last\s+\|\s+Doe/) }
      its(:stdout) { should match(/\s+age\s+\|\s+84/) }
    end
  end
end
