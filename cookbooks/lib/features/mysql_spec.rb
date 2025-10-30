# frozen_string_literal: true

def reset_sql
  Support.tmpdir.join('reset.sql')
end

describe 'mysql installation' do
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

  describe 'mysql commands' do
    before do
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

    describe command('echo "SHOW VARIABLES LIKE \'innodb_flush_log_at_trx_commit\'" | mysql'), dev: true do
      its(:stdout) { should include('innodb_flush_log_at_trx_commit	0') }
    end
  end
end
