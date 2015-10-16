describe 'rabbitmq installation', mega: true, standard: true do
  describe package('rabbitmq-server') do
    it { should be_installed }
  end

  describe 'rabbitmq commands', sudo: true do
    before :all do
      system(
        'sudo service rabbitmq-server start',
        [:out, :err] => '/dev/null'
      )
      tcpwait('127.0.0.1', 5672)
    end

    describe service('rabbitmq') do
      it { should be_running }
    end

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
    before :all do
      system(
        'sudo service rabbitmq-server start',
        [:out, :err] => '/dev/null'
      )
      sleep 5
    end

    before :each do
      system(
        './spec/bin/rabbitmqadmin declare queue ' \
        'name=my-test-queue durable=false',
        [:out, :err] => '/dev/null'
      )
      system(
        './spec/bin/rabbitmqadmin publish exchange=amq.default ' \
        'routing_key=my-test-queue payload="hello, world"',
        [:out, :err] => '/dev/null'
      )
      sleep 2
    end

    describe command('./spec/bin/rabbitmqadmin list queues') do
      its(:stdout) { should include('my-test-queue') }
    end

    describe command(
      './spec/bin/rabbitmqadmin get queue=my-test-queue requeue=false'
    ) do
      its(:stdout) { should include('my-test-queue', 'hello, world') }
    end
  end
end
