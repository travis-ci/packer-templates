# frozen_string_literal: true

def couchdb_url
  return 'http://127.0.0.1:5984' if %w[trusty xenial].include?(Support.distro)

  'http://admin:travis@127.0.0.1:5984'
end

describe 'couchdb installation' do
  describe package('couchdb') do
    it { should be_installed }
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
      sh("curl -X PUT #{couchdb_url}/bicycle")
      sh("curl -H Content-Type: 'application/json' -X PUT #{couchdb_url}/bicycle/bell -d '{
      \"Name\": \"Testname\"}'")
    end

    describe command("curl #{couchdb_url}/") do
      its(:stdout) { should match '"couchdb":"Welcome"' }
    end

    describe command("curl -X GET #{couchdb_url}/_all_dbs") do
      its(:stdout) { should match 'bicycle' }
    end

    describe command("curl -X GET #{couchdb_url}/bicycle/bell") do
      its(:stdout) { should include('_id', 'bell', 'Name', 'Testname') }
    end
  end
end
