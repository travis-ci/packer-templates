def bzr_project
  Support.tmpdir.join('bzr-project')
end

describe 'bazaar installation' do
  describe command('bzr version') do
    its(:stdout) { should match(/Bazaar \(bzr\)/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'bazaar commands' do
    before :each do
      bzr_project.rmtree if bzr_project.exist?
      sh("bzr init #{bzr_project}")
      bzr_project.join('test.txt').write("floof\n")
    end

    describe command(%(
      cd #{bzr_project};
      bzr status;
      bzr add test.txt;
      bzr status;
    )) do
      [
        /adding test\.txt/,
        /unknown.+test\.txt/,
        /added:.+test\.txt/
      ].each do |pattern|
        its(:stdout) { should match(pattern) }
      end
    end
  end
end
