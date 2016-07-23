describe 'python environment' do
  describe command('python --version') do
    its(:stdout) { should be_empty }
    its(:stderr) { should match(/^Python \d+\.\d+\.\d+/) }
  end

  describe command('easy_install --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^setuptools \d+\.\d+\.\d+/) }
  end

  describe command('pip --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^pip \d+\.\d+\.\d+/) }
  end

  describe command('wheel version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^wheel \d+\.\d+\.\d+/) }
  end

  describe command('py.test --version') do
    its(:stdout) { should be_empty }
    its(:stderr) { should match(/pytest version \d+\.\d+\.\d+/) }
  end

  describe command('nosetests --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^nosetests version \d+\.\d+\.\d+/) }
  end

  describe command(
    %q{python -c 'import mock,sys;sys.stdout.write(mock.__version__ + "\n")'}
  ) do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  end
end
