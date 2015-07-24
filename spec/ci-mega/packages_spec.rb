describe 'ci-mega packages' do
  describe package('build-essential'), if: os[:family] == 'ubuntu' do
    it { should be_installed }
  end
end
