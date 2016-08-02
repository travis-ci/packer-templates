describe 'mongodb installation' do
  describe command('mongo --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/MongoDB shell/) }
  end

  describe 'mongo commands', sudo: true do
    before :all do
      sh('sudo service mongodb start')
      procwait(/\bmongod\b/)
      sh('mongo --eval "db.testData.insert( { x : 6 } );"')
    end

    describe command('mongo --eval "var myCursor = db.testData.find( { x: 6 }); myCursor.forEach(printjson);"') do
      its(:stdout) { should match(/{ "_id" : ObjectId\("\w+"\), "x" : 6 }/) }
    end
  end
end
