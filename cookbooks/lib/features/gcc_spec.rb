describe 'gcc installation' do
  before :all do
    cp(
      Support.libdir.join('features/files/hai.c'),
      Support.tmpdir.join('hai.c')
    )
    empty_dir = Support.tmpdir.join('empty')
    rm_rf(empty_dir)
    mkdir_p(empty_dir)
  end

  describe command('gcc -v') do
    its(:stderr) { should match(/^gcc version/) }
  end

  describe command("cd #{Support.tmpdir.join('empty')} && gcc") do
    its(:stderr) { should include('no input files') }
  end

  describe command(%(
    cd #{Support.tmpdir};
    gcc -Wall -o hai hai.c;
    ./hai there
  )) do
    its(:stdout) { should match(/^hai 2$/) }
  end
end
