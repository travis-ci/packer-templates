describe 'emacs installation' do
  describe command('emacs --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'add a file and write text into it with emacs' do
    before do
      sh('emacs -batch ./spec/files/flower.txt --eval ' \
         '\'(insert "Butterblume")\' -f save-buffer')
    end

    describe file('./spec/files/flower.txt') do
      its(:content) { should match 'Butterblume' }
    end
  end
end
