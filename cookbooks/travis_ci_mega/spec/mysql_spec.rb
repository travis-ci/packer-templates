describe 'mysql installation' do
  describe command('mysql --version') do
    its(:stdout) { should match(/^mysql /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'mysql commands' do
    before do
      system('bash', '-c', 'mysql <<< "DROP DATABASE travis" || true')
      system('bash', '-c', 'mysql <<< "CREATE DATABASE travis"')
      system('bash', '-c', 'mysql travis <<< "CREATE TABLE test(id int)"')
      system('bash', '-c', "mysql travis <<< 'INSERT INTO test(id) VALUES(#{rand_id})'")
    end

    let(:rand_id) { rand(10_000...19_999) }

    describe command('bash', '-c', 'mysql <<< "SHOW DATABASES"') do
      its(:stdout) { should match(/^travis\$/) }
    end

    describe command('bash', '-c', 'mysql travis <<< "SELECT id FROM test"') do
      its(:stdout) { should match(/^#{rand_id}$/) }
    end
  end
end
