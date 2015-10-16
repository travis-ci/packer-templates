describe 'gcc installation', mega: true, standard: true, minimal: true do
  before :all do
    system(
      %w(
        mkdir -p /tmp/travis-images-specs/gcc ;
        cd /tmp/travis-images-specs/gcc ;
        find . -type f | xargs rm -rf
      ).join(' '),
      [:out, :err] => '/dev/null'
    )
  end

  describe command('gcc -v') do
    its(:stderr) { should match(/^gcc version/) }
  end

  describe command('gcc') do
    its(:stderr) { should include('gcc:', 'no input files') }
  end
end
