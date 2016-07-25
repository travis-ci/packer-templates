describe 'ruby environment' do
  describe command('ruby --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^ruby \d+\.\d+\.\d+/) }
  end

  describe command('gem --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  end

  describe command('bundle --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^Bundler version \d+\.\d+\.\d+/) }
  end

  describe command('rspec --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  end
end
