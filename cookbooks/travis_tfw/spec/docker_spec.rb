# frozen_string_literal: true

require 'support'

include Support::Helpers

describe 'tiny floating whale docker setup', docker: false do
  before :all do
    sh('sudo service docker start')
  end

  describe service('docker') do
    it { should be_enabled }
    it { should be_running }
  end

  describe package('lvm2') do
    it { should be_installed }
  end

  describe package('xfsprogs') do
    it { should be_installed }
  end

  describe file('/etc/default/docker-chef') do
    it { should exist }
    its(:content) { should include('Chef manages') }
  end

  describe file('/etc/default/docker') do
    it { should exist }
    its(:content) { should include('left blank') }
  end

  describe file('/etc/init/docker.conf') do
    it { should exist }
    its(:content) { should include('$TRAVIS_DOCKER_DISABLE_DIRECT_LVM') }
  end
end
