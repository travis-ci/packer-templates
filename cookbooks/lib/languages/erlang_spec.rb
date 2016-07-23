describe 'erlang environment' do
  describe command(
    'erl -eval "' \
      'erlang:display(erlang:system_info(otp_release)), halt().' \
     '" -noshell'
  ) do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^"\d+/) }
  end

  describe command('kerl version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  end

  describe command('rebar --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^rebar \d+\.\d+\.\d+/) }
  end
end
