describe 'ragel installation' do
  describe package('ragel') do
    it { should be_installed }
  end

  describe command('ragel -v') do
    its(:stdout) { should match(/^Ragel /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'ragel commands' do
    describe 'add a ragel file and execute a ragel command' do
      before do
        hw_rl = Support.tmpdir.join('hello_world.rl')
        hw_rl.write('puts "Hello World"')
        sh("ragel -R #{hw_rl}")
      end

      describe file(Support.tmpdir.join('hello_world.rb').to_s) do
        its(:content) { should match(/^puts "Hello World"/) }
      end
    end
  end
end
