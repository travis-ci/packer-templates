# frozen_string_literal: true

describe 'docker-compose installation' do
  describe command('docker-compose --version') do
    its(:exit_status) { should eq 0 }
    if %w[bionic jammy noble].include?(Support.distro)
      its(:stdout) { should match(/^(Docker Compose|docker-compose) version:? v?\d+\.\d+\.\d+/) }
    end
  end
end
