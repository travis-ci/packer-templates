def test_txt
  Support.tmpdir.join('test.txt')
end

describe 'vim installation' do
  describe command('vim --version') do
    its(:stdout) { should_not be_empty }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end

  before do
    test_txt.write("their\n")
    sh("vim #{test_txt} -c s/their/there -c wq")
  end

  describe file(test_txt) do
    its(:content) { should match(/there/) }
  end
end
