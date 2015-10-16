describe 'dictionaries installation', mega: true, standard: true, minimal: true do
  describe package('wamerican') do
    it { should be_installed }
  end
end

describe 'dictionaries commands', mega: true, standard: true, minimal: true do
  describe command('look colonize') do
    its(:stdout) { should include('colonize', 'colonized', 'colonizer', 'colonizers', 'colonizes') }
  end
end
