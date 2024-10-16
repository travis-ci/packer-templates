# frozen_string_literal: true

require 'features/go_toolchain_spec'

describe 'go installation' do
  describe command('go version') do
    its(:stdout) { should_not be_empty }
  end
end
