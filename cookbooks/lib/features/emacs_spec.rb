describe 'emacs installation' do
  describe command('emacs --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'editing' do
    before do
      FileUtils.cp(
        File.join(Support.libdir, 'features/files/flower.txt'),
        File.join(Support.tmpdir, 'flower.txt')
      )
      sh(
        "emacs -batch #{Support.tmpdir}/flower.txt " \
        "--eval '(insert \"Butterblume\")' -f save-buffer"
      )
    end

    describe file("#{Support.tmpdir}/flower.txt") do
      its(:content) { should match 'Butterblume' }
    end
  end
end
