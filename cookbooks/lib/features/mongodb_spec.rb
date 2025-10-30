# frozen_string_literal: true

describe 'mongodb installation' do
  describe command('mongod --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'mongodb commands' do
    before :all do
      sh('sudo systemctl start mongod && sudo service mongod start')
      procwait(/\bmongod\b/)
      sleep 3
      sh('mongosh --eval "db.testData.insert({ x: 6 });"')
      sleep 3
    end

    describe command(%Q(mongosh --eval "var myCursor = db.testData.find({x:6}); myCursor.forEach(printjson);")) do
      its(:exit_status) { should eq 0 }
    end

    after :all do
      sh('sudo systemctl stop mongod && sudo service mongod stop || true')
    end
  end
end
