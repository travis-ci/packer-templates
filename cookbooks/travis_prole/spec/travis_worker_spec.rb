# frozen_string_literal: true

require 'support'

include Support::Helpers

describe 'prole setup', docker: false do
  before :all do
    sh('sudo service docker start')
  end

  describe service('docker'), legacy: false do
    it { should be_enabled }
    it { should be_running }
  end
end
