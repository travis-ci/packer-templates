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
    its(:stdout) { should match(/^pip \d+\.\d+\.\d+/) }
  end

  describe pycommand('wheel version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^wheel \d+\.\d+\.\d+/) }
  end

  describe pycommand('py.test --version') do
    its(:stdout) { should be_empty }
    its(:stderr) { should match(/pytest version \d+\.\d+\.\d+/) }
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

  {
    'python2.7' => '2.7.13',
    'python3.5' => '3.5.3'
  }.each do |python_alias, python_version|
    describe pycommand('python -m this', version: python_alias) do
      its(:stderr) { should be_empty }
      its(:stdout) { should include('Now is better than never') }
      its(:exit_status) { should eq(0) }
    end

    describe pycommand('python --version', version: python_alias) do
      stream = python_alias < 'python3' ? :stderr : :stdout
      its(stream) { should include("Python #{python_version}") }
    end
  end
end
