describe 'docker installation' do
  describe command('docker version --format="{{.Client.Version}}" || true') do
    its(:stdout) { should match(/^1\.\d+\.\d+/) }
  end

  describe command(
    'docker version --format="{{.Server.Version}}" || true'
  ), docker: false do
    its(:stdout) { should match(/^1\.\d+\.\d+/) }
  end
end
