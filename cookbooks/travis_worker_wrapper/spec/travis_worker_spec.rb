require 'support'

include Support::Helpers

describe 'travis-worker setup', docker: false do
  before :all do
    sh('sudo service docker start')
    sh('sudo service travis-worker start')
  end

  describe service('docker'), legacy: false do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('travis-worker') do
    it { should be_enabled }
    it { should be_running }
  end
end
