# frozen_string_literal: true

describe 'docker installation' do
  describe command('docker version --format="{{.Client.Version}}" || true') do
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  end

  describe command(
    'docker version --format="{{.Server.Version}}" || true'
  ), docker: false do
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  end
end
