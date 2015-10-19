describe 'dictionaries installation' do
  describe package('wamerican') do
    it { should be_installed }
  end
end

describe 'dictionaries commands' do
  describe command('look kid') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^kidnappers$/) }
    its(:stdout) { should match(/^kidding$/) }
    its(:stdout) { should match(/^kidney$/) }
  end
end
