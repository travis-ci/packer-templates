describe 'mysql installation' do
  describe command('mysql --version') do
    its(:stdout) { should match(/^mysql /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'mysql commands' do
    before do
      system('mysql < ./spec/files/mysql-reset.sql')
      system('mysql travis < ./spec/files/mysql-schema.sql')
    end

    describe command('echo "SHOW DATABASES" | mysql') do
      its(:stdout) { should match(/^travis$/) }
    end

    describe command('echo "SELECT id FROM test" | mysql travis') do
      its(:stdout) { should match(/^4$/) }
    end
  end
end
