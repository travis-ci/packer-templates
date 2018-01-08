# frozen_string_literal: true

require 'support'

def rmq
  @rmq ||= Support::RabbitMQAdmin.new
end

describe 'rabbitmq installation' do
  before :all do
    sh('sudo service rabbitmq-server start')
    tcpwait('127.0.0.1', 5672)
    sh("#{rmq.exe} declare queue " \
       'name=my-test-queue durable=false')
    sh("#{rmq.exe} publish exchange=amq.default " \
       'routing_key=my-test-queue payload="hello, world"')
    sleep 2
  end

  describe package('rabbitmq-server') do
    it { should be_installed }
  end

  describe 'rabbitmq commands', sudo: true do
    if os[:release] !~ /16/
      describe command('sudo service rabbitmq-server status') do
        its(:stdout) { should match 'running_applications' }
      end
    else
      describe command('sudo service rabbitmq-server status') do
        its(:stdout) { should include('active (running)') }
      end
    end

    describe command('sudo rabbitmqctl status') do
      its :stdout do
        should match(/Status of node '?rabbit@/)
        should include('running_applications')
      end
    end
  end

  describe 'rabbitmqadmin commands', sudo: true do
    describe command("#{rmq.exe} list queues") do
      its(:stdout) { should include('my-test-queue') }
    end
  end
end
