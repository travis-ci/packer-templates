describe 'postgresql installation' do
  describe command('psql --version') do
    its(:stdout) { should match(/^psql /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'psql commands' do
    before do
      sh('dropdb -U travis test_db || true')
      sh('createdb -U travis test_db')
    end

    after do
      sh('dropdb -U travis test_db || true')
    end

    describe command('psql -U travis -ltA') do
      its(:stdout) { should match(/^test_db\|/) }
    end

    context 'with a test table' do
      before do
        sh('psql -U travis -c "CREATE TABLE test_table();" test_db')
      end

      describe command("psql -U travis -tA -c '\\dt' test_db") do
        its(:stdout) { should match(/^public\|test_table\|/) }
        its(:stderr) { should be_empty }
      end
    end
  end
end
