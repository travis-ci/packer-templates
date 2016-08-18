require 'support'

describe 'git installation' do
  describe package('git') do
    it { should be_installed }
  end

  describe command('git --version') do
    its(:stdout) { should match(/^git version (2\.|1\.[89])/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('git config user.name'), dev: true, precise: false do
    its(:stdout) { should match(/travis/i) }
  end

  describe command('git config user.email'), dev: true, precise: false do
    its(:stdout) { should match(/travis@example\.org/) }
  end

  describe 'git commands' do
    before :each do
      sh(%W(
        rm -rf #{Support.tmpdir}/git-project ;
        git init #{Support.tmpdir}/git-project ;
        touch #{Support.tmpdir}/git-project/test-file.txt
      ).join(' '))
    end

    describe command(
      %W(
        cd #{Support.tmpdir}/git-project ;
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
