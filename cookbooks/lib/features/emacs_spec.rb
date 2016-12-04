def test_txt
  Support.tmpdir.join('test.txt')
end

describe 'emacs installation' do
  describe command('emacs --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'editing' do
    before do
      test_txt.write("daisy\n")
      sh(
        "emacs -batch #{test_txt} " \
        "--eval '(insert \"Butterblume\")' -f save-buffer"
      )
    end

    describe file(test_txt) do
      its(:content) { should match 'Butterblume' }
    end
  end
end
