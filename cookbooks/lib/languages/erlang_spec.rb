# frozen_string_literal: true

include Support::Erlang

describe 'erlang environment' do
  describe erlcommand(
    'erl -eval "' \
      'erlang:display(erlang:system_info(otp_release)), halt().' \
     '" -noshell'
  ) do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^"R?\d+/) }
  end

  describe erlcommand('kerl list builds') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^R?\d+/) }
  end

  describe erlcommand('rebar --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^rebar \d+\.\d+\.\d+/) }
  end
end
