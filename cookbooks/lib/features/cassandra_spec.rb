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
  describe command('which cassandra') do
    its(:stdout) { should match 'bin/cassandra' }
  end

  describe 'cassandra commands', sudo: true do
    before :all do
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
        > USE travis;
        > INSERT INTO users (first, last, age)
        > VALUES ('Slappy', 'Squirrel', '108');
      EOF

      query_cql.write(<<-EOF.gsub(/^\s+> /, ''))
        > USE travis;
        > EXPAND ON;
        > SELECT * FROM users WHERE first = 'Slappy';
      EOF

      sh('sudo service cassandra start')
      tcpwait('localhost', 9042)

      sh("cqlsh -f #{schema_cql}")
      sh("cqlsh -f #{seed_cql}")
    end

    after :all do
      sh('sudo service cassandra stop')
    end

    describe service('cassandra') do
      it { should be_running }
    end

    describe command('cqlsh --version') do
      its(:stdout) { should match(/cqlsh \d/) }
    end

    describe command("cqlsh --no-color --debug -f #{query_cql}") do
      its(:stdout) { should match(/\s+first\s+\|\s+Slappy/) }
      its(:stdout) { should match(/\s+last\s+\|\s+Squirrel/) }
      its(:stdout) { should match(/\s+age\s+\|\s+108/) }
      its(:stderr) { should match(/Using CQL driver:/) }
    end
  end
end
