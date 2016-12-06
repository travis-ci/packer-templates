def schema_cql
  Support.tmpdir.join('schema.cql')
end

def seed_cql
  Support.tmpdir.join('seed.cql')
end

def query_cql
  Support.tmpdir.join('query.cql')
end

describe 'cassandra installation' do
  before do
    schema_cql.write(<<-EOF.gsub(/^\s+> /, ''))
      > CREATE KEYSPACE travis
      > WITH REPLICATION = {
      >   'class': 'SimpleStrategy',
      >   'replication_factor': 1
      > };
      > USE travis;
      > CREATE TABLE users (
      >   first varchar PRIMARY KEY,
      >   last varchar,
      >   age varchar,
      > );
    EOF

    seed_cql.write(<<-EOF.gsub(/^\s+> /, ''))
      > INSERT INTO users (first, last, age)
      > VALUES ('Jane', 'Doe', '84');
    EOF

    query_cql.write(<<-EOF.gsub(/^\s+> /, ''))
      > EXPAND ON;
      > SELECT * FROM users WHERE first = 'Jane';
    EOF
  end

  describe command('which cassandra') do
    its(:stdout) { should match '/local/bin/cassandra' }
  end

  describe 'cassandra commands', sudo: true do
    before :all do
      sh('sudo /etc/init.d/cassandra start')
      sleep 10
      sh("cqlsh -f #{schema_cql}")
      sh("cqlsh -f #{seed_cql}")
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

    describe command("cqlsh --no-color --debug -f #{query_cql}") do
      its(:stdout) { should match(/\s+first\s+\|\s+Jane/) }
      its(:stdout) { should match(/\s+last\s+\|\s+Doe/) }
      its(:stdout) { should match(/\s+age\s+\|\s+84/) }
    end
  end
end
