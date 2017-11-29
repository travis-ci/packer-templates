# frozen_string_literal: true

describe 'ruby installation' do
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
    its(:stdout) { should match(/^RSpec \d+\.\d+/) }
  end
end
