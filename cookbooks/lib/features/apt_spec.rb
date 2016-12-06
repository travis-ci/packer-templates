describe 'apt installation' do
  describe command('apt-get -v') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/var/lib/apt/lists') do
    it { should be_directory }
  end

  describe '/var/lib/apt/lists/*Packages*' do
    it 'is non-empty' do
      expect(Dir.glob('/var/lib/apt/lists/*Packages*')).to_not be_empty
    end
  end

  describe command('apt-cache search ubuntu-restricted-extras') do
    its(:stdout) { should_not be_empty }
  end

  describe 'apt commands', sudo: true do
    describe command('sudo apt-get update -y') do
      its(:stdout) { should match(/http/) }
    end

    describe command('sudo apt-get install -y language-pack-pt') do
      its(:stdout) { should match(/Reading state/) }
    end
  end
end
