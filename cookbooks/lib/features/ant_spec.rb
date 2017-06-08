# frozen_string_literal: true

describe 'ant installation' do
  describe command('ant -version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'ant command' do
    describe command('ant -diagnostics') do
      its(:stdout) { should include('Ant diagnostics report') }
    end

    describe command('ant') do
      its(:stdout) { should match 'Buildfile: build.xml does not exist!' }
    end
  end
end
