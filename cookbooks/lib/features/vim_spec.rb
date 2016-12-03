def flower_txt
  Support.tmpdir.join('flower.txt')
end

describe 'vim installation' do
  describe command('vim --version') do
    its(:stdout) { should_not be_empty }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end

  before do
    flower_txt.write("blume\n")
    sh("vim #{flower_txt} -c s/blume/flower -c wq")
  end

  describe file(flower_txt) do
    its(:content) { should match(/flower/) }
  end
end
