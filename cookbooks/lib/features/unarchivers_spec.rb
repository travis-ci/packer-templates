describe 'unarchivers installation' do
  describe command('gzip --version') do
    its(:stdout) { should match(/^gzip \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('bzip2 --version') do
    its(:stderr) { should match(/^bzip.*Version \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('zip --version') do
    its(:stdout) { should match(/Zip \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('unzip -version') do
    its(:stdout) { should match(/^UnZip \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('dpkg -s libbz2-dev') do
    its(:stdout) { should match 'Status: install ok installed' }
  end

  before :each do
    Support.tmpdir.join('test.txt').write("Konstantin broke all the things\n")
  end

  describe command(
    %(
      gzip #{Support.tmpdir}/test.txt;
      rm #{Support.tmpdir}/test.txt;
      ls #{Support.tmpdir};
      gzip -d #{Support.tmpdir}/test.txt.gz;
      cat #{Support.tmpdir}/test.txt
    )
  ) do
    its(:stdout) { should include('test.txt.gz') }
    its(:stdout) { should match 'Konstantin broke all the things.' }
  end

  describe command(
    %(
      bzip2 -z #{Support.tmpdir}/test.txt;
      rm #{Support.tmpdir}/test.txt;
      ls #{Support.tmpdir};
      bzip2 -d #{Support.tmpdir}/test.txt.bz2;
      cat #{Support.tmpdir}/test.txt
    )
  ) do
    its(:stdout) { should include('test.txt.bz2') }
    its(:stdout) { should match 'Konstantin broke all the things.' }
  end

  describe command(
    %(
      zip #{Support.tmpdir}/test.txt.zip #{Support.tmpdir}/test.txt;
      rm #{Support.tmpdir}/test.txt;
      ls #{Support.tmpdir};
      unzip -d #{Support.tmpdir} #{Support.tmpdir}/test.txt.zip;
      cat #{Support.tmpdir}/test.txt
    )
  ) do
    its(:stdout) { should include('test.txt.zip') }
    its(:stdout) { should match 'Konstantin broke all the things' }
  end
end
