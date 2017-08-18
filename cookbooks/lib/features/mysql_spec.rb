# frozen_string_literal: true

def reset_sql
  Support.tmpdir.join('reset.sql')
end

def schema_sql
  Support.tmpdir.join('schema.sql')
end

def user_host_combinations
  [
    "'root'@'%'",
    "'root'@'127.0.0.1'",
    "'root'@'localhost'",
    "'travis'@'%'",
    "'travis'@'127.0.0.1'",
    "'travis'@'localhost'"
  ].map { |user_host| user_host.delete("'").split('@', 2) }
end

def expected_privileges
  %w[
    Select
    Insert
    Update
    Delete
    Create
    Drop
    Reload
    Shutdown
    Process
    File
    Grant
    Index
    Show_db
    Super
    Create_tmp_table
    Lock_tables
    Execute
    Create_view
    Show_view
    Create_routine
    Alter_routine
    Create_user
    Event
    Trigger
    Create_tablespace
  ]
end

def privilege_check_queries
  user_host_combinations.map do |user, host|
    expected_privileges.map do |priv_column|
      <<-EOF.gsub(/^\s+> /, '')
        > SELECT #{priv_column}_priv
        > FROM mysql.user
        > WHERE Host = '#{host}'
        >   AND User = '#{user}'
      EOF
    end
  end.flatten
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
    it { should be_readable }
    it { should be_owned_by 'travis' }
    it { should be_grouped_into 'travis' }
  end

  describe 'mysql commands' do
    before do
      sh("mysql <#{reset_sql}")
      sh("mysql travis <#{schema_sql}")
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

    privilege_check_queries.each do |query|
      describe command(%(echo "#{query}" | mysql -N)), dev: true do
        its(:stdout) { should eql("Y\n") }
      end
    end
  end
end
