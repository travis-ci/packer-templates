describe 'postgres installation' do
  describe command('psql --version') do
    its(:stdout) { should match(/^psql /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'psql commands' do
    before do
      sh('dropdb test_db || true ; createdb test_db')
    end

    after do
      sh('dropdb test_db || true')
    end

    describe command('psql -ltA') do
      its(:stdout) { should match(/^test_db\|/) }
    end

    describe command(
      'psql -c "CREATE TABLE test_table();" test_db ; ' \
      'psql -tAc "\dt" test_db'
    ) do
      its(:stdout) { should match(/^public\|test_table\|/) }
    end
  end
end
