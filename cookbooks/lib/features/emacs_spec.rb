describe 'emacs installation' do
  describe command('emacs --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'add a file and write text into it with emacs' do
    before do
      sh("emacs -batch #{Support.libdir}/features/files/flower.txt --eval " \
         '\'(insert "Butterblume")\' -f save-buffer')
    end

    describe file("#{Support.libdir}/features/files/flower.txt") do
      its(:content) { should match 'Butterblume' }
    end
  end
end
