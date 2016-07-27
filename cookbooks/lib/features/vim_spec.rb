describe 'vim installation' do
  describe command('vim --version') do
    its(:stdout) { should_not be_empty }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end

  describe 'vim commands' do
    describe 'batch editing' do
      before do
        File.write("#{Support.libdir}/features/files/flower.txt", "blume\n")
        sh("vim #{Support.libdir}/features/files/flower.txt -c s/blume/flower -c wq")
      end

      describe file("#{Support.libdir}/features/files/flower.txt") do
        its(:content) { should match(/flower/) }
      end
    end
  end
end
