include Support::Python

require 'features/python_interpreter_spec'

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
    %q{python -c 'import mock,sys;sys.stdout.write(mock.__version__ + "\n")'}
  ) do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  end
end
