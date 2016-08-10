def mongodb_service_name
  return 'mongod' if `lsb_release -sc 2>/dev/null`.strip == 'trusty'
  'mongodb'
end

describe 'mongodb installation' do
  describe service(mongodb_service_name), dev: true do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe command('mongo --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/MongoDB shell/) }
  end

  describe 'mongo commands', docker: false, fixme: true do
    # FIXME: This suite does not currently work inside docker because the
    # upstart config for mongo 3.2 apparently will not do.  Rather than shipping
    # our own upstart conf, or patching the upstream one, or worse, this suite
    # is disabled.  Additionally, we don't advertise or guarantee functioning
    # mongo installations on trusty+docker.

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
