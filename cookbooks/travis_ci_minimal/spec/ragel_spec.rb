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
        File.open('./spec/files/hello_world.rl', 'w') do |f|
          f.puts 'puts "Hello World"'
        end
        sh('ragel -R ./spec/files/hello_world.rl')
      end

      describe file('./spec/files/hello_world.rb') do
        its(:content) { should match(/^puts "Hello World"/) }
      end
    end
  end
end
