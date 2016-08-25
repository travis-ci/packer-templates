include Support::Python

describe 'python interpreter' do
  describe pycommand('python --version 2>&1') do
    its(:stdout) { should match(/^Python \d+\.\d+\.\d+/) }
  end

  describe pycommand('python -m this') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/Readability counts\./) }
  end
end
