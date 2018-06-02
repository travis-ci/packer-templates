# frozen_string_literal: true

include Support::Postgresql

describe 'postgresql installation' do
  describe pgcommand('psql --version') do
    its(:stdout) { should match(/^psql.+(9\.[4-6]+\.[0-9]+|10\.[0-9])/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'psql commands' do
    before do
      sh("#{pg_path} dropdb -U travis test_db || true")
      sh("#{pg_path} createdb -U travis test_db")
    end

    after do
      sh("#{pg_path} dropdb -U travis test_db || true")
    end

    describe pgcommand('psql -U travis -ltA') do
      its(:stdout) { should match(/^test_db\|/) }
    end

    context 'with a test table' do
      before do
        sh(%{#{pg_path} psql -U travis -c "CREATE TABLE test_table();" test_db})
      end

      describe pgcommand("psql -U travis -tA -c '\\dt' test_db") do
        its(:stdout) { should match(/^public\|test_table\|/) }
        its(:stderr) { should be_empty }
      end
    end
  end
end
