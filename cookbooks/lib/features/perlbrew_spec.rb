# frozen_string_literal: true

describe 'perlbrew installation' do
  perlbrew_cmd = 'source ~/perl5/perlbrew/etc/bashrc && perlbrew'

  describe command("#{perlbrew_cmd} --version") do
    its(:stdout) { should match(/App::perlbrew\/\d+\.\d+/) }
    its(:exit_status) { should eq 0 }
  end

  describe command("#{perlbrew_cmd} list") do
    its(:stdout) { should match(/^\s*\d+\.\d+\.\d+/) }
    its(:exit_status) { should eq 0 }
  end
end
