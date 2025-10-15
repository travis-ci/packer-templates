# frozen_string_literal: true

include Support::Python

require 'features/python_interpreter_spec'
require 'features/pyenv_spec'

describe 'python environment' do
  describe pycommand('python3 -m pip --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^pip \d+\.\d+(\.\d+)?/) }
  end

  describe pycommand('python3 -m wheel version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^wheel \d+\.\d+\.\d+/) }
  end

  describe pycommand('python3 -m pytest --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/pytest( version)? \d+\.\d+\.\d+/) }
  end

  describe pycommand('python3 -m nose --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/nose.*\d+\.\d+/) }
  end

  describe pycommand(
    %q(python3 -c 'import sys; import unittest.mock as m; sys.stdout.write("mock-ok\n")')
  ) do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^mock-ok/) }
  end


  if 'xenial'.include?(Support.distro)
    vers = {
      'python2.7' => '2.7.18',
      'python3.7' => '3.7.17',
      'python3.8' => '3.8.13'
    }
  elsif 'bionic'.include?(Support.distro)
    vers = {
      'python3.6' => '3.6.15',
      'python3.7' => '3.7.17',
      'python3.8' => '3.8.18',
      'python3.12' => '3.12.4'
    }
  elsif 'focal'.include?(Support.distro)
    vers = {
      'python3.7' => '3.7.17',
      'python3.8' => '3.8.18',
      'python3.9' => '3.9.18',
      'python3.12' => '3.12.4'
    }
  elsif 'jammy'.include?(Support.distro)
    vers = {
      'python3.7' => '3.7.17',
      'python3.8' => '3.8.18',
      'python3.10' => '3.10.14',
      'python3.12' => '3.12.4'
    }
  elsif 'noble'.include?(Support.distro)
    vers = {
      'python3.12' => '3.12.8',
      'python3.13' => '3.13.1'
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
