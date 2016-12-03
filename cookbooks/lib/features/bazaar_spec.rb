describe 'bazaar installation' do
  describe command('bzr version') do
    its(:stdout) { should match(/Bazaar \(bzr\)/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'bazaar commands' do
    before :each do
      sh(%(
        rm -rf #{Support.tmpdir}/bzr-project;
        bzr init #{Support.tmpdir}/bzr-project;
        touch #{Support.tmpdir}/bzr-project/test-file
      ))
    end

    describe command(%(
      cd #{Support.tmpdir}/bzr-project;
      bzr status;
      bzr add test-file;
      bzr status;
    )) do
      its(:stdout) { should match(/adding test-file/) }
      its(:stdout) { should include('unknown:', 'test-file') }
      its(:stdout) { should include('added:', 'test-file') }
    end
  end
end
