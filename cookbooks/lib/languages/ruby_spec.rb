# frozen_string_literal: true

describe 'ruby installation' do
  describe command('gem --version') do
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('rspec --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^RSpec \d+\.\d+/) }
  end
end
