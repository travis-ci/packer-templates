describe 'docker-compose installation' do
  describe command('docker-compose --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^docker-compose version: \d+\.\d+\.\d+/) }
  end
end
