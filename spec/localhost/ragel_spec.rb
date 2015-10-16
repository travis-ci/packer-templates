describe 'ragel installation', mega: true, standard: true, minimal: true do
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
        system('ragel -R ./spec/files/hello_world.rl')
      end

      describe command('cat ./spec/files/hello_world.rb') do
        its(:stdout) { should match(/^puts "Hello World"/) }
      end
    end
  end
end
