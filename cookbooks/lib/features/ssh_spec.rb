describe 'ssh access' do
  %w(known_hosts authorized_keys).each do |basename|
    describe file(::File.expand_path("~/.ssh/#{basename}")) do
      it { should exist }
      its(:size) { should be > 0 }
      it { should be_readable }
      it { should be_writable }
    end
  end
end
