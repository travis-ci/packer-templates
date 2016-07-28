include Support::Python

describe 'python interpreter' do
  describe pycommand('python --version') do
    its(:stdout) { should be_empty }
    its(:stderr) { should match(/^Python \d+\.\d+\.\d+/) }
  end

  describe pycommand('python -m this') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/Readability counts\./) }
  end
end
