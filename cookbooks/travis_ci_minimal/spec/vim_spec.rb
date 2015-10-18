describe 'vim installation' do
  describe command('vim --version') do
    its(:stdout) { should_not be_empty }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end

  describe 'vim commands' do
    describe 'add a file and replace text with vim' do
      before do
        File.write('./spec/files/flower.txt', "blume\n")
      end

      describe command('vim flower.txt -c s/blume/flower -c wq') do
        its(:stderr) { should be_empty }
        its(:stdout) { should match 'flower' }
      end
    end
  end
end
