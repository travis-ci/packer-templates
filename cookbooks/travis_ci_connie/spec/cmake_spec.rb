describe 'cmake installation' do
  describe command('cmake --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^cmake version 3/) }
  end
end
