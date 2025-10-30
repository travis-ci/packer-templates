# frozen_string_literal: true

include Support::Php

if os[:arch] !~ /ppc64|aarch64|arm64/
  describe 'php interpreter' do
    describe command('php --version') do
      its(:stdout) { should match(/^PHP \d+\.\d+/) }
      its(:stderr) { should be_empty }
    end

    describe command('php -r "echo 1;"') do
      its(:stderr) { should be_empty }
      its(:exit_status) { should eq 0 }
    end
  end
end
