def empty_dir
  Support.tmpdir.join('empty')
end

describe 'gcc installation' do
  before :all do
    Support.tmpdir.join('hai.c').write(<<-EOF.gsub(/^\s+> /, ''))
      > #include <stdio.h>
      > int
      > main(int argc, char *argv[]) {
      >   printf("hai %d\\n", argc);
      > }
    EOF
    empty_dir.rmtree if empty_dir.exist?
    empty_dir.mkpath
  end

  describe command('gcc -v') do
    its(:stderr) { should match(/^gcc version/) }
  end

  describe command("cd #{empty_dir} && gcc") do
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
