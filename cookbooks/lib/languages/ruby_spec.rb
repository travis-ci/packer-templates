describe 'ruby installation' do
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

  describe command(%(ruby -e 'puts RUBY_ENGINE')) do
    its(:stdout) { should match(/^ruby/) }
  end

  describe command(%(ruby -e 'puts "Konstanin broke all the things!"')) do
    its(:stdout) { should match(/^Konstanin broke all the things!$/) }
  end
end
