describe 'rabbitmq installation' do
  before :all do
    sh('sudo service rabbitmq-server start')

    procwait(/rabbitmq_server/, 30)

    sh('./spec/bin/rabbitmqadmin declare queue ' \
       'name=my-test-queue durable=false')
    sh('./spec/bin/rabbitmqadmin publish exchange=amq.default ' \
       'routing_key=my-test-queue payload="hello, world"')
  end

  describe package('rabbitmq-server') do
    it { should be_installed }
  end

  describe 'rabbitmq commands', sudo: true do
    describe command('sudo service rabbitmq-server status') do
      its(:stdout) { should match 'running_applications' }
    end

    describe command('sudo rabbitmqctl status') do
      its :stdout do
        should match(/Status of node '?rabbit@/)
        should include('running_applications')
      end
    end
  end

  describe 'rabbitmqadmin commands', sudo: true do
    describe command('./spec/bin/rabbitmqadmin list queues') do
      its(:stdout) { should include('my-test-queue') }
    end

    describe command('./spec/bin/rabbitmqadmin get queue=my-test-queue') do
      its(:stdout) { should include('my-test-queue', 'hello, world') }
    end
  end
end
