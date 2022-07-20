# frozen_string_literal: true

include Support::Python

require 'features/python_interpreter_spec'
require 'features/pyenv_spec'

describe 'python environment' do
  describe pycommand('easy_install --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^setuptools \d+\.\d+\.\d+/) }
  end

  describe pycommand('pip --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^pip \d+\.\d+(\.\d+)?/) }
  end

  describe pycommand('wheel version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^wheel \d+\.\d+\.\d+/) }
  end

  if %w[xenial bionic].include?(Support.distro)
    describe pycommand('py.test --version') do
      its(:stdout) { should be_empty }
      its(:stderr) { should match(/pytest (version )?\d+\.\d+\.\d+/) }
    end
  elsif 'focal'.include?(Support.distro)
    describe pycommand('py.test --version') do
      its(:stderr) { should be_empty }
      its(:stdout) { should match(/pytest (version )?\d+\.\d+\.\d+/) }
    end
  end

  describe pycommand('nosetests --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^nosetests version \d+\.\d+\.\d+/) }
  end

  describe pycommand(
    %q(python -c 'import mock,sys;sys.stdout.write(mock.__version__ + "\n")')
  ) do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  end

  if 'xenial'.include?(Support.distro)
    vers = {
      'python2.7' => '2.7.15',
      'python3.6' => '3.6.7',
      'python3.7' => '3.7.1'
    }
  elsif 'bionic'.include?(Support.distro)
    vers = {
      'python2.7' => '2.7.17',
      'python3.6' => '3.6.10',
      'python3.7' => '3.7.6',
      'python3.8' => '3.8.1'
    }
  elsif 'focal'.include?(Support.distro)
    vers = {
      'python3.7' => '3.7.7',
      'python3.8' => '3.8.13'
    }
  end

  vers.each do |python_alias, python_version|
    describe pycommand('python -m this', version: python_alias), dev: true do
      its(:stderr) { should be_empty }
      its(:stdout) { should include('Now is better than never') }
      its(:exit_status) { should eq(0) }
    end

    describe pycommand('python --version', version: python_alias), dev: true do
      stream = python_alias < 'python3' ? :stderr : :stdout
      its(stream) { should include("Python #{python_version}") }
    end
  end
end
