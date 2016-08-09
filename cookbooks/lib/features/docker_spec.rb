describe 'docker installation' do
  describe command('docker version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^Client:/) }
    its(:stdout) { should match(/^ Version:\s+1\.\d+\.\d+/) }
  end
end
