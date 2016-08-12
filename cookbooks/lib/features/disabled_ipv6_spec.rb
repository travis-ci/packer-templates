describe 'disabled ipv6' do
  describe command('ip addr') do
    its(:stdout) { should_not match(/\binet6\s+.+::.+scope\s+link/) }
  end

  describe file('/etc/hosts') do
    its(:contents) { should_not match(/::1.+\blocalhost\b/) }
  end
end
