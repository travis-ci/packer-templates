# frozen_string_literal: true

describe 'redis installation' do
  describe command('redis-server --version') do
    its(:stdout) { should match(/^Redis /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'redis commands' do
    before :all do
      spawn('redis-server', '--port', '16379', %i[out err] => '/dev/null')
      tcpwait('127.0.0.1', 16_379)
    end

    before :each do
      sh('redis-cli -p 16379 SET test_key test_value')
    end

    describe command('redis-cli -p 16379 PING') do
      its(:stdout) { should match(/^PONG$/) }
    end

    describe command('redis-cli -p 16379 GET test_key | cat') do
      its(:stdout) { should match(/^test_value$/) }
    end
  end
end
