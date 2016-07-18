describe 'bazaar installation' do
  describe command('bzr version') do
    its(:stdout) { should match(/Bazaar \(bzr\)/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'bazaar commands' do
    before :each do
      sh(%w(rm -rf bzr-project ;
            bzr init bzr-project ;
            touch bzr-project/test-file.rb).join(' '))
    end

    describe command(
      'cd bzr-project ; bzr status ; bzr add test-file.rb ; bzr status'
    ) do
      its(:stdout) { should match(/adding test-file.rb/) }
      its(:stdout) { should include('unknown:', 'test-file.rb') }
      its(:stdout) { should include('added:', 'test-file.rb') }
    end
  end
end
