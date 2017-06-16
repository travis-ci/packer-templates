# frozen_string_literal: true

describe 'sqlite installation' do
  before :each do
    rm_rf(Support.tmpdir.join('test.db'))
  end

  describe command('sqlite3 -version') do
    its(:stdout) { should match(/^\d\.\d/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'sqlite commands are executed' do
    describe command(%(
      sqlite3 #{Support.tmpdir}/test.db "
        CREATE TABLE hats (
          id INTEGER PRIMARY KEY,
          name TEXT,
          style INTEGER
        );
        INSERT INTO hats VALUES(1, 'floppy', 9001);
        SELECT * FROM hats;
      "
    )) do
      its(:stdout) { should match '1|floppy|9001' }
    end
  end
end
