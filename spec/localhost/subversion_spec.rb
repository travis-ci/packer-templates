describe 'subversion installation', mega: true, standard: true, minimal: true do
  describe command('svn --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'subversion commands are executed' do
    describe command('svnadmin create svn-project; cat svn-project/README.txt') do
      its(:stdout) { should match 'This is a Subversion repository;' }
    end
  end
end
