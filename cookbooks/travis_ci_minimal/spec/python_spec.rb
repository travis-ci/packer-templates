describe 'python and pip installation' do
  describe command('python --version') do
    its(:stderr) { should match(/^Python /) }
    its(:exit_status) { should eq 0 }
  end

  describe command('pip --version') do
    its(:stdout) { should match(/^pip /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'python commands' do
    describe command('python -c "print 123 + 123"') do
      its(:stdout) { should match(/^246$/) }
    end

    describe command('python -m this') do
      its(:stdout) { should match(/it may be a good idea\.$/) }
    end
  end
end
