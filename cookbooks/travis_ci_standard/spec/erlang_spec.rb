describe 'system erlang installation' do
  describe command("/usr/bin/erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell") do
    its(:stdout) { should match(/R14B04/) }
  end
end
