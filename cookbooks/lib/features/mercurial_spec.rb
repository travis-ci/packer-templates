describe 'mercurial installation' do
  describe command('hg version') do
    its(:stdout) { should match(/^Mercurial Distributed SCM \(version \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'mecurial commands are executed' do
    before :all do
      sh(%w(
        rm -rf hg-test-project ;
        hg init hg-test-project ;
        touch hg-test-project/test-file.txt
      ).join(' '))
    end

    describe command(
      %w(
        cd hg-test-project ;
        hg status ;
        hg add . ;
        hg status
      ).join(' ')
    ) do
      its(:stdout) { should match '\? test-file.txt' }
      its(:stdout) { should match 'A test-file.txt' }
    end
  end
end
