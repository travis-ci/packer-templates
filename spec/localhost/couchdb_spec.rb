describe 'couchdb installation', standard: true do
  describe package('couchdb') do
    it { should be_installed }
  end

  describe command('couchdb -V') do
    its(:exit_status) { should eq 0 }
  end

  describe 'couchdb commands', sudo: true do
    before :all do
      system('sudo service couchdb start')
      system('sleep 5')
      system('curl -X PUT http://127.0.0.1:5984/baseball')
      system('curl -X PUT http://127.0.0.1:5984/baseball/bat -H \'Content-Type: application/json\' -d \'{"Name":"Testname"}\'')
    end

    describe command('curl http://127.0.0.1:5984/') do
      its(:stdout) { should match '"couchdb":"Welcome"' }
    end

    describe command('curl -X GET http://127.0.0.1:5984/_all_dbs') do
      its(:stdout) { should match 'baseball' }
    end

    describe command('curl -X GET http://127.0.0.1:5984/baseball/bat') do
      its(:stdout) { should include('_id', 'bat', 'Name', 'Testname') }
    end
  end
end
