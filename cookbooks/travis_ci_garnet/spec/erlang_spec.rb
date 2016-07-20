describe 'erlang versions' do
  %w(
    17.5
    18.2.1
    R14B04
    R15B03
    R16B03-1
  ).each do |otp_release|
    describe file("/home/travis/otp/#{otp_release}/activate") do
      it { should exist }
      it { should be_readable }
    end
  end
end
