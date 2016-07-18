describe 'unarchivers installation' do
  describe 'unarchivers versions' do
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
  end

  describe 'unarchivers commands' do
    describe command('dpkg -s libbz2-dev') do
      its(:stdout) { should match 'Status: install ok installed' }
    end

    describe command(
      %w(
        gzip ./spec/files/unarchivers.txt ;
        ls ./spec/files/ ;
        gzip -d ./spec/files/unarchivers.txt.gz ;
        cat ./spec/files/unarchivers.txt
      ).join(' ')
    ) do
      its(:stdout) { should include('unarchivers.txt.gz') }
      its(:stdout) { should match 'Konstantin broke all the things.' }
    end

    describe command(
      %w(
        bzip2 -z ./spec/files/unarchivers.txt ;
        ls ./spec/files/ ;
        bzip2 -d ./spec/files/unarchivers.txt.bz2 ;
        cat ./spec/files/unarchivers.txt
      ).join(' ')
    ) do
      its(:stdout) { should include('unarchivers.txt.bz2') }
      its(:stdout) { should match 'Konstantin broke all the things.' }
    end

    describe command(
      %w(
        zip ./spec/files/unarchivers.txt.zip ./spec/files/unarchivers.txt ;
        ls ./spec/files ;
        unzip ./spec/files/unarchivers2.txt.zip ;
        cat unarchivers2.txt
      ).join(' ')
    ) do
      its(:stdout) { should include('unarchivers.txt.zip') }
      its(:stdout) { should match 'Konstantin broke all the things' }
    end
  end
end
