describe 'gimme installation' do
  describe command('gimme --version') do
    its(:exit_status) { should eq 0 }
  end

  describe command(%(eval "$(HOME=#{Support.tmpdir} gimme 1.6.3)")) do
    its(:stdout) { should match 'go version go1.6.3' }
  end
end
