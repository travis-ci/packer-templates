describe 'dictionaries installation' do
  describe package('wamerican') do
    it { should be_installed }
  end
end

describe 'dictionaries commands' do
  describe command('look colonize') do
    its(:stdout) { should include('colonize', 'colonized', 'colonizer', 'colonizers', 'colonizes') }
  end
end
