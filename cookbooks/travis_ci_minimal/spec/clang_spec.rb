describe 'clang installation' do
  describe command('clang -v') do
    its(:exit_status) { should eq 0 }
  end

  describe 'clang command' do
    describe command('clang -help') do
      its(:stdout) { should include('OVERVIEW: clang LLVM compiler', 'OPTIONS:') }
    end
  end
end
