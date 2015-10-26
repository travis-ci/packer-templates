describe 'gimme installation' do
  describe command('gimme --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'gimme commands' do
    describe command('eval "$(gimme 1.3)"; go version') do
      its(:stdout) { should match 'go version go1.3 linux/amd64' }
    end
  end
end
