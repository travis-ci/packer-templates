describe 'git installation' do
  describe package('git') do
    it { should be_installed }
  end

  describe command('git --version') do
    its(:stdout) { should match(/^git version (2\.|1\.[89])/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'git commands' do
    before :each do
      sh(%w(
        rm -rf git-project ;
        git init git-project ;
        touch git-project/test-file.txt
      ).join(' '))
    end

    describe command(
      %w(
        cd git-project ;
        git status ;
        git add test-file.txt ;
        git status ;
        git add test-file.txt ;
        git rm -f test-file.txt ;
        git status
      ).join(' ')
    ) do
      its(:stdout) { should include('Untracked files:', 'test-file.txt') }
      its(:stdout) { should include('Changes to be committed:', 'new file:   test-file.txt') }
      its(:stdout) { should match(/nothing to commit/) }
    end
  end
end
