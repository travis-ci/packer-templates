def hg_project
  Support.tmpdir.join('hg-project')
end

describe 'mercurial installation' do
  describe command('hg version') do
    its(:stdout) { should match(/^Mercurial Distributed SCM \(version \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'mecurial commands are executed' do
    before :all do
      hg_project.rmtree if hg_project.exist?
      sh("hg init #{hg_project}")
      hg_project.join('test-file.txt').write("violin\n")
    end

    describe command(
      %W(
        cd #{hg_project};
        hg status;
        hg add .;
        hg status
      ).join(' ')
    ) do
      its(:stdout) { should match '\? test-file.txt' }
      its(:stdout) { should match 'A test-file.txt' }
    end
  end
end
