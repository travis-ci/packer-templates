describe 'sqlite installation' do
  describe command('sqlite3 -version') do
    its(:stdout) { should match(/\d\.\d/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'sqlite commands are executed' do
    describe command('sqlite3 test.db "CREATE TABLE Cars(Id INTEGER PRIMARY KEY, Name TEXT, Price INTEGER);
                      INSERT INTO Cars VALUES(1,\'Audi\',52642);
                      SELECT * FROM Cars;"') do
      its(:stdout) { should match '1|Audi|52642' }
    end
  end
end
