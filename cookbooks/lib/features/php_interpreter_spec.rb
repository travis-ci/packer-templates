# frozen_string_literal: true

include Support::Php

if os[:arch] !~ /ppc64|aarch64|arm64/
  describe 'php interpreter' do
    describe phpcommand('php --version') do
      its(:stdout) { should be_empty }
      its(:stderr) { should match(/^PHP \d+\.\d+/) }
    end

    describe phpcommand(
      %(php -r 'foreach (range(1, 5) as $i) { echo $i * 2 . " "; } echo "\n";')
    ) do
      its(:stderr) { should be_empty }
      its(:stdout) { should match(/^2 4 6 8 10/) }
    end
  end
end
