describe 'sysctl installation' do
  describe command('sysctl -V') do
    its(:exit_status) { should eq 0 }
  end

  describe 'sysctl commands are executed' do
    describe command('sysctl -a') do
      its(:stdout) { should include('kernel.sched_child_runs_first') }
    end
  end
end
