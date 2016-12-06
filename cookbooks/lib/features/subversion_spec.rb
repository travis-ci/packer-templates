def svn_project
  Support.tmpdir.join('svn-project')
end

describe 'subversion installation' do
  describe command('svn --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'subversion commands are executed' do
    before do
      svn_project.rmtree if svn_project.exist?
      sh("svnadmin create #{svn_project}")
    end

    after do
      svn_project.rmtree if svn_project.exist?
    end

    describe file(svn_project.join('README.txt')) do
      its(:content) { should match 'This is a Subversion repository;' }
    end
  end
end
