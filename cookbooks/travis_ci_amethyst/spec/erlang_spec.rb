describe 'erlang versions' do
  %w(
    19.0
    18.3
  ).each do |otp_release|
    describe file("/home/travis/otp/#{otp_release}/activate") do
      it { should exist }
      it { should be_readable }
    end
  end
end
