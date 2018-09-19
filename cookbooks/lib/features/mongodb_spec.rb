# frozen_string_literal: true

def mongodb_service_name
  return 'mongod' if %w[trusty xenial].include?(Support.distro) && os[:arch] !~ /ppc64/

  'mongodb'
end

describe 'mongodb installation' do
  describe service(mongodb_service_name) do
    # Note these will pass even if the service doesn't exist / has a different name.
    # Unfortunately serverspec doesn't support `exists` for services, however the
    # DB inserts below will at least fail if mongodb_service_name is incorrect.
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe command('mongo --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/MongoDB shell/) }
  end

  describe 'mongo commands' do
    before :all do
      sh("sudo service #{mongodb_service_name} start")
      procwait(/\bmongod\b/)
      sleep 3 # HACK: thanks a bunch, Mongo
      sh('mongo --eval "db.testData.insert( { x : 6 } );"')
      sleep 3 # HACK: thanks a bunch more, Mongo
    end

    after :all do
      sh("sudo service #{mongodb_service_name} stop || true")
    end

    describe command('mongo --eval "var myCursor = db.testData.find( { x: 6 }); myCursor.forEach(printjson);"') do
      its(:stdout) { should match(/{ "_id" : ObjectId\("\w+"\), "x" : 6 }/) }
    end
  end
end
