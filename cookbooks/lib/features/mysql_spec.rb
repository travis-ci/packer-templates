describe 'mysql installation' do
  before :all do
    sh('sudo service mysql-5.6 start || sudo service mysql start')
  end

  after :all do
    sh('sudo service mysql-5.6 stop || sudo service mysql stop')
  end

  describe command('mysql --version') do
    its(:stdout) { should match(/^mysql /) }
    its(:exit_status) { should eq 0 }
  end

  describe file('/home/travis/.my.cnf') do
    it { should exist }
    it { should be_readable }
    it { should be_readable }
    it { should be_owned_by 'travis' }
    it { should be_grouped_int 'travis' }
  end

  describe 'mysql commands' do
    before do
      sh("mysql < #{Support.libdir}/features/files/mysql-reset.sql")
      sh("mysql travis < #{Support.libdir}/features/files/mysql-schema.sql")
    end

    describe command('echo "SHOW DATABASES" | mysql') do
      its(:stdout) { should match(/^travis$/) }
    end

    describe command('echo "SELECT id FROM test" | mysql travis') do
      its(:stdout) { should match(/^4$/) }
    end
  end
end
