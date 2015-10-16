describe 'emacs installation', mega: true, standard: true do
  describe command('emacs --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'add a file and write text into it with emacs' do
    before do
      system(
        'emacs -batch ./spec/files/flower.txt --eval ' \
        '\'(insert "Butterblume")\' -f save-buffer',
        [:out, :err] => '/dev/null'
      )
    end

    describe command('cat ./spec/files/flower.txt') do
      its(:stdout) { should match 'Butterblume' }
    end
  end
end
