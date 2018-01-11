# frozen_string_literal: true

describe 'couchdb installation' do
  describe package('couchdb') do
    it { should be_installed }
  end

  describe command('couchdb -V') do
    its(:exit_status) { should eq 0 }
  end

  describe 'couchdb commands', sudo: true do
    before :all do
      tries = 5
      begin
        sh('sudo service couchdb start')
        tcpwait('127.0.0.1', 5984, 30)
      rescue StandardError => e
        tries -= 1
        retry unless tries.zero?
        raise e
      end
      sh('curl -X PUT http://127.0.0.1:5984/bicycle')
      sh('curl -X PUT http://127.0.0.1:5984/bicycle/bell ' \
         '-H \'Content-Type: application/json\' -d \'{"Name":"Testname"}\'')
    end

    describe command('curl http://127.0.0.1:5984/') do
      its(:stdout) { should match '"couchdb":"Welcome"' }
    end

    describe command('curl -X GET http://127.0.0.1:5984/_all_dbs') do
      its(:stdout) { should match 'bicycle' }
    end

    describe command('curl -X GET http://127.0.0.1:5984/bicycle/bell') do
      its(:stdout) { should include('_id', 'bell', 'Name', 'Testname') }
    end
  end
end
