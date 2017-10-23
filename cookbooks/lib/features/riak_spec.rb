# frozen_string_literal: true

if os[:arch] !~ /ppc64/
  describe 'riak installation', sudo: true do
    before :all do
      sh('sudo riak start')
    end

    describe package('riak') do
      it { should be_installed }
    end

    describe command('riak version') do
      its(:stdout) { should match(/^\d/) }
      its(:exit_status) { should eq 0 }
    end

    describe command('sudo riak ping') do
      its(:stdout) { should match(/^pong$/) }
    end

    describe command(
      'for n in 0 1 2 3 4 ; do ' \
        'sudo riak-admin test || true ; ' \
        'echo ; ' \
        'sleep 1 ; ' \
      'done'
    ) do
      its(:stdout) { should match(%r{^Successfully completed 1 read/write cycle}) }
    end
  end
end
