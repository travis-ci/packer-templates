# frozen_string_literal: true

include Support::Php

require 'features/php_interpreter_spec'

if os[:arch] !~ /ppc64|aarch64|arm64/
  describe 'php environment' do
    describe phpcommand('php-fpm --version') do
      its(:exit_status) { should eq 0 }
    end

    describe file('/home/travis/.pearrc') do
      it { should_not exist }
    end
  end
end
