# frozen_string_literal: true

def reset_sql
  Support.tmpdir.join('reset.sql')
end

def schema_sql
  Support.tmpdir.join('schema.sql')
end

describe 'mysql installation' do
  before :all do
    reset_sql.write(<<-EOF.gsub(/^\s+> /, ''))
      > DROP DATABASE IF EXISTS travis;
      > CREATE DATABASE travis;
    EOF
    schema_sql.write(<<-EOF.gsub(/^\s+> /, ''))
      > CREATE TABLE test(id int);
      > INSERT INTO test(id) VALUES(4); -- fair dice roll
    EOF
    sh('sudo service mysql start')
  end

  describe file('/home/travis/.my.cnf') do
    it { should exist }
    it { should be_readable }
    it { should be_owned_by 'travis' }
    it { should be_grouped_into 'travis' }
  end

  describe file('/etc/mysql/conf.d/innodb_flush_log_at_trx_commit.cnf'), dev: true do
    it { should exist }
    it { should be_readable }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/mysql/conf.d/performance-schema.cnf') do
    it { should exist }
    it { should be_readable }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe 'mysql commands' do
    before do
      sh("mysql <#{reset_sql}")
      sh("mysql travis <#{schema_sql}")
      sh('sudo service mysql restart')
    end

    %w[
      root
      travis
    ].each do |mysql_user|
      describe command(%(mysql -u #{mysql_user} -e 'select "hai"')) do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match(/hai/) }
        its(:stderr) { should be_empty }
      end
    end

    describe command('echo "SHOW DATABASES" | mysql') do
      its(:stdout) { should match(/^travis$/) }
    end

    describe command('echo "SELECT id FROM test" | mysql travis') do
      its(:stdout) { should match(/^4$/) }
    end

    describe command('echo "SHOW VARIABLES LIKE \'performance_schema\'" | mysql') do
      its(:stdout) { should include('performance_schema	OFF') }
    end

    describe command('echo "SHOW VARIABLES LIKE \'innodb_flush_log_at_trx_commit\'" | mysql'), dev: true do
      its(:stdout) { should include('innodb_flush_log_at_trx_commit	0') }
    end
  end
end
