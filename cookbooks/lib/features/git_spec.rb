describe 'git installation' do
  describe package('git') do
    it { should be_installed }
  end

  describe command('git --version') do
    its(:stdout) { should match(/^git version (2\.|1\.[89])/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('git config user.name'), precise: false do
    its(:stdout) { should match(/travis/i) }
  end

  describe command('git config user.email'), precise: false do
    its(:stdout) { should match(/travis@example\.org/) }
  end

  describe 'git commands' do
    before :each do
      git_project = Support.tmpdir.join('git-project')
      git_project.rmtree
      sh("git init #{git_project}")
      git_project.join('test-file.txt').write("hippo\n")
    end

    describe command(
      %W(
        cd #{Support.tmpdir.join('git-project')};
        git status;
        git add test-file.txt;
        git status;
        git add test-file.txt;
        git rm -f test-file.txt;
        git status
      ).join(' ')
    ) do
      its(:stdout) do
        should include(
          'Untracked files:',
          'test-file.txt',
          'Changes to be committed:',
          'new file:   test-file.txt'
        )
      end
      its(:stdout) { should match(/nothing to commit/) }
    end
  end
end
