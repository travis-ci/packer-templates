describe 'mongodb installation' do
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
      sh('sudo service mongodb start')
      procwait(/\bmongod\b/)
      sh('mongo --eval "db.testData.insert( { x : 6 } );"')
      sleep 3 # HACK: thanks a bunch, Mongo
    end

    after :all do
      sh('sudo service mongodb stop || true')
    end

    describe command('mongo --eval "var myCursor = db.testData.find( { x: 6 }); myCursor.forEach(printjson);"') do
      its(:stdout) { should match(/{ "_id" : ObjectId\("\w+"\), "x" : 6 }/) }
    end
  end
end
