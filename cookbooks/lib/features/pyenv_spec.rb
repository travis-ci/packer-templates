# frozen_string_literal: true

require 'json'

describe 'pyenv', dev: true do
  if %w[jammy].include?(Support.distro)
    describe command('pyenv version-name') do
      its(:stdout) { should eql("3.10.14\n") }
    end
  elsif %w[noble].include?(Support.distro)
    describe command('pyenv version-name') do
      its(:stdout) { should eql("3.12.8\n") }
    end
  else
    describe command('pyenv version-name') do
      its(:stdout) { should eql("3.7.17\n") }
    end
  end
  describe command('pyenv root') do
    its(:stdout) { should eql("/opt/pyenv\n") }
  end

  describe 'PATH' do
    it 'does not include any /opt/python entries' do
      expect(
        ENV['PATH'].split(':').any? { |e| e =~ %r{^/opt/python} }
      ).to be false
    end
  end

  %w[
    python
    python3
  ].each do |py|
    describe "default sys.path for #{py}" do
      it 'does not include any /opt/python entries' do
        sys_path = JSON.parse(
          `#{py} -c "import sys,json;json.dump(sys.path, sys.stdout)"`
        )
        expect(
          sys_path.any? { |e| e =~ %r{^/opt/python} }
        ).to be false
      end
    end
  end
end
