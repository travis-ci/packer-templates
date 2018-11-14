# frozen_string_literal: true

describe 'apt installation' do
  describe command('apt-get -v') do
    its(:exit_status) { should eq 0 }
  end

  describe file('/var/lib/apt/lists') do
    it { should be_directory }
  end

  describe '/var/lib/apt/lists/*Packages*' do
    it 'is non-empty' do
      expect(Dir.glob('/var/lib/apt/lists/*Packages*')).to_not be_empty
    end
  end

  describe command('apt-cache search ubuntu-restricted-extras') do
    its(:stdout) { should_not be_empty }
  end

  describe 'apt commands', sudo: true do
    describe command('sudo apt-get update -y') do
      its(:stdout) { should match(/http/) }
    end

    describe command('sudo apt-get install -y language-pack-pt') do
      its(:stdout) { should match(/Reading state/) }
    end
  end

  describe 'apt architecture' do
    if os[:arch] =~ /ppc64/
      describe command('dpkg --print-architecture') do
        its(:stdout) { should match(/ppc/) }
      end

      describe command('dpkg --print-foreign-architectures') do
        its(:stdout) { should be_empty }
      end
    else
      describe command('dpkg --print-architecture') do
        its(:stdout) { should match(/amd64/) }
      end

      describe command('dpkg --print-foreign-architectures') do
        its(:stdout) { should match(/i386/) }
      end
    end
  end
end

describe command('bats --version') do
  its(:stdout) { should match(/^Bats \d/) }
end

describe command('shellcheck --version') do
  its(:stdout) { should match(/^version: \d+\.\d+\.\d+/) }
end

if os[:arch] !~ /ppc64/
  describe command('shfmt -version') do
    its(:stdout) { should match(/^v\d+\.\d+\.\d+/) }
  end
end

def bzr_project
  Support.tmpdir.join('bzr-project')
end

describe 'bazaar installation' do
  describe command('bzr version') do
    its(:stdout) { should match(/Bazaar \(bzr\)/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'bazaar commands' do
    before :each do
      bzr_project.rmtree if bzr_project.exist?
      sh("bzr init #{bzr_project}")
      bzr_project.join('test.txt').write("floof\n")
    end

    describe command(%(
      cd #{bzr_project};
      bzr status;
      bzr add test.txt;
      bzr status;
    )) do
      [
        /^unknown:/,
        /^  test\.txt/,
        /^adding test\.txt/,
        /^added:/,
        /^  test\.txt/
      ].each do |pattern|
        its(:stdout) { should match(pattern) }
      end
    end
  end
end

describe 'ccache installation' do
  describe command('ccache -V') do
    its(:exit_status) { should eq 0 }
  end

  describe 'ccache commands are executed' do
    describe command('ccache -s') do
      its(:stdout) do
        should include(
          'cache directory',
          'cache hit',
          'cache miss',
          'files in cache',
          'max cache size'
        )
      end
    end

    describe command('ccache -M 0.5') do
      its(:stdout) do
        should match(/Set cache size limit to (512\.0 Mbytes|500\.0 MB)/)
      end
    end
  end
end

describe 'clang installation' do
  describe command('clang -v') do
    its(:exit_status) { should eq 0 }
  end

  describe 'clang command' do
    describe command('clang -help') do
      its(:stdout) do
        should include(
          'OVERVIEW: clang LLVM compiler',
          'OPTIONS:'
        )
      end
    end
  end
end

describe package('pollinate') do
  it { should be_installed }
end

describe file('/etc/cloud/templates') do
  it { should be_directory }
end

describe file('/etc/cloud/cloud.cfg') do
  its(:content) { should match(/managed by chef/i) }
  its(:content) { should match(/travis_build_environment/i) }
end

%w[
  /etc/cloud/templates/hosts.debian.tmpl
  /etc/cloud/templates/hosts.tmpl
  /etc/cloud/templates/hosts.ubuntu.tmpl
].each do |filename|
  describe file(filename) do
    it { should be_exist }
    its(:content) { should match(/managed by chef/i) }
    its(:content) { should match(/travis_build_environment/i) }
  end
end

%w[
  /etc/cloud/templates/sources.list.debian.tmpl
  /etc/cloud/templates/sources.list.tmpl
  /etc/cloud/templates/sources.list.ubuntu.tmpl
].each do |filename|
  describe file(filename) do
    its(:content) { should match(/managed by chef/i) }
    its(:content) { should match(/travis_build_environment/i) }
  end
end

describe command('cmake --version') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^cmake version [23]/) }
end

describe 'dictionaries installation' do
  describe package('wamerican') do
    it { should be_installed }
  end
end

describe 'dictionaries commands' do
  describe command('look kid') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^kidnappers$/) }
    its(:stdout) { should match(/^kidding$/) }
    its(:stdout) { should match(/^kidney$/) }
  end
end

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

describe 'gimme installation' do
  describe command('gimme --version') do
    its(:exit_status) { should eq 0 }
  end

  if os[:arch] !~ /ppc64/
    describe command(%(eval "$(HOME=#{Support.tmpdir} gimme 1.6.3)" 2>&1)) do
      its(:stdout) { should match 'go version go1.6.3' }
    end
  elsif os[:arch] =~ /ppc64/
    describe command(%(eval "$(HOME=#{Support.tmpdir} gimme 1.6.4)" 2>&1)) do
      its(:stdout) { should match 'go version go1.6.4 linux/ppc64le' }
    end
  end
end

def git_project
  Support.tmpdir.join('git-project')
end

describe 'git installation' do
  describe package('git') do
    it { should be_installed }
  end

  describe command('git --version') do
    its(:stdout) { should match(/^git version (2\.|1\.[89])/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('git config user.name') do
    its(:stdout) { should match(/travis/i) }
  end

  describe command('git config user.email') do
    its(:stdout) { should match(/travis@example\.org/) }
  end

  describe 'git commands' do
    before :each do
      git_project.rmtree if git_project.exist?
      sh("git init #{git_project}")
      git_project.join('test-file.txt').write("hippo\n")
    end

    describe command(
      %W[
        cd #{git_project};
        git status;
        git add test-file.txt;
        git status;
        git add test-file.txt;
        git rm -f test-file.txt;
        git status
      ].join(' ')
    ) do
      its(:stdout) do
        should include(
          'Untracked files:',
          'test-file.txt',
          'Changes to be committed:',
          'new file:   test-file.txt'
        )
      end
      its(:stdout) { should match(/nothing to commit/) }
    end
  end
end

if os[:arch] !~ /ppc64/
  describe command('heroku version') do
    its(:stdout) { should match(/^heroku/) }
  end
end

describe 'imagemagick installation' do
  describe command('convert --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/imagemagick/i) }
  end

  describe 'imagemagick commands' do
    before do
      logo_gif = Support.tmpdir.join('logo.gif')
      logo_gif.unlink if logo_gif.exist?
      sh("convert logo: #{logo_gif}")
    end

    describe command("identify #{Support.tmpdir.join('logo.gif')}") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/logo\.gif GIF/) }
    end
  end
end

def test_json
  Support.tmpdir.join('test.json')
end

describe 'jq installation' do
  before do
    test_json.write(<<-EOF.gsub(/^\s+> /, ''))
      > {
      >   "stuff": [
      >     {
      >       "@type": "smarm",
      >       "msg": [
      >         "Konstantin broke all the things"
      >       ]
      >     },
      >     {
      >       "@type": "empty"
      >     }
      >   ]
      > }
    EOF
  end

  describe command('jq -V') do
    its(:exit_status) { should eq 0 }
  end

  describe command(
    %(jq -r '.stuff|.[]|select(."@type"=="smarm")|.msg[0]' <#{test_json})
  ) do
    its(:stdout) { should match(/^Konstantin broke all the things/) }
  end
end

def md5deep_txt
  Support.tmpdir.join('md5deep.txt')
end

describe 'md5deep installation' do
  before do
    md5deep_txt.write("Konstantin broke all the things in m5deep!\n")
  end

  describe command('md5deep -v') do
    its(:exit_status) { should eq 0 }
  end

  describe command('md5deep -V') do
    its(:stdout) { should match 'This program is a work of the US Government.' }
  end

  describe command("md5deep #{md5deep_txt}") do
    its(:stdout) { should match(/^29c04665afa6ef18edc38824ceaff6ab\b/) }
  end
end

def hg_project
  Support.tmpdir.join('hg-project')
end

describe 'mercurial installation' do
  describe command('hg version') do
    its(:stdout) { should match(/^Mercurial Distributed SCM \(version \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'mecurial commands are executed' do
    before :all do
      hg_project.rmtree if hg_project.exist?
      sh("hg init #{hg_project}")
      hg_project.join('test-file.txt').write("violin\n")
    end

    describe command(
      %W[
        cd #{hg_project};
        hg status;
        hg add .;
        hg status
      ].join(' ')
    ) do
      its(:stdout) { should match '\? test-file.txt' }
      its(:stdout) { should match 'A test-file.txt' }
    end
  end
end

describe command('mysql --version') do
  its(:stdout) { should match(/^mysql /) }
  its(:exit_status) { should eq 0 }
end

describe 'openssl installation' do
  describe command('openssl version') do
    its(:stdout) { should match(/^OpenSSL/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'openssl commands' do
    describe command(
      'echo "Konstantin broke all the things." | openssl enc -base64'
    ) do
      its(:stdout) do
        should match 'S29uc3RhbnRpbiBicm9rZSBhbGwgdGhlIHRoaW5ncy4K'
      end
    end

    describe command(
      'echo "S29uc3RhbnRpbiBicm9rZSBhbGwgdGhlIHRoaW5ncy4K" ' \
      '| openssl enc -base64 -d'
    ) do
      its(:stdout) { should match 'Konstantin broke all the things.' }
    end
  end
end

describe command('packer version') do
  its(:stdout) { should match(/^Packer v\d/) }
  its(:exit_status) { should eq 0 }
end

describe command('psql --version') do
  its(:stdout) { should match(/^psql.+(9\.[4-6]+\.[0-9]+|10\.[0-9])/) }
  its(:exit_status) { should eq 0 }
end

describe 'ragel installation' do
  describe package('ragel') do
    it { should be_installed }
  end

  describe command('ragel -v') do
    its(:stdout) { should match(/^Ragel /) }
    its(:exit_status) { should eq 0 }
  end

  describe 'ragel commands' do
    describe 'add a ragel file and execute a ragel command' do
      before do
        hw_rl = Support.tmpdir.join('hello_world.rl')
        hw_rl.write('puts "Hello World"')
        sh("ragel -R #{hw_rl}")
      end

      describe file(Support.tmpdir.join('hello_world.rb').to_s) do
        its(:content) { should match(/^puts "Hello World"/) }
      end
    end
  end
end

describe 'ruby interpreter' do
  describe command('ruby --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^ruby 2\.\d+\.\d+/) }
  end

  describe command(%(ruby -e 'puts RUBY_ENGINE')) do
    its(:stdout) { should match(/^ruby/) }
  end

  describe command(%(ruby -e 'puts "Konstanin broke all the things!"')) do
    its(:stdout) { should match(/^Konstanin broke all the things!$/) }
  end
end

describe 'rvm installation' do
  describe command('rvm version') do
    its(:stdout) { should match(/^rvm /) }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end

  describe 'rvm commands' do
    describe command('rvm list') do
      its(:stdout) { should include('current') }
      its(:stdout) { should match(/ruby-2\.[234]\.\d/) }
      its(:stderr) { should be_empty }
    end

    describe command('rvm default do echo whatever') do
      its(:stderr) { should_not include('Warning!') }
      its(:stdout) { should_not include('Warning!') }
      its(:stdout) { should include('whatever') }
    end
  end

  %w[
    /home/travis/.rvmrc
    /home/travis/.rvm/user/db
  ].each do |filename|
    describe file(filename) do
      it { should exist }
      it { should be_writable }
      it { should be_readable }
    end
  end
end

describe command('ssh -V') do
  its(:stderr) { should match(/OpenSSH/) }
end

describe 'ssh access' do
  %w[known_hosts authorized_keys].each do |basename|
    describe file(::File.expand_path("~/.ssh/#{basename}")) do
      it { should exist }
      its(:size) { should be_positive }
      it { should be_readable }
      it { should be_writable }
    end
  end
end

def svn_project
  Support.tmpdir.join('svn-project')
end

describe 'subversion installation' do
  describe command('svn --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'subversion commands are executed' do
    before do
      svn_project.rmtree if svn_project.exist?
      sh("svnadmin create #{svn_project}")
    end

    after do
      svn_project.rmtree if svn_project.exist?
    end

    describe file(svn_project.join('README.txt')) do
      its(:content) { should match 'This is a Subversion repository;' }
    end
  end
end

describe command('sudo -V') do
  its(:stdout) { should match(/^Sudo version \d/) }
end

describe 'sudoers setup' do
  before { RSpec.configure { set :shell, '/tmp/sudo-bash' } }
  after { RSpec.configure { set :shell, '/bin/bash' } }

  describe file('/etc/sudoers') do
    it { should exist }
    it { should be_file }
    it { should be_mode 440 }
    it { should be_owned_by 'root' }
    its(:content) { should match(%r{^#includedir /etc/sudoers\.d$}) }
  end

  describe file('/etc/sudoers.d/travis') do
    it { should exist }
    it { should be_file }
    it { should be_mode 440 }
    it { should be_owned_by 'root' }
    its(:content) { should match(/^travis ALL=\(ALL\) NOPASSWD:ALL$/) }
    %w[authenticate env_reset mail_badpass].each do |disabled|
      its(:content) { should match(/^Defaults !#{disabled}$/) }
    end
  end
end

describe 'sysctl installation' do
  describe command('sysctl -V') do
    its(:exit_status) { should eq 0 }
  end

  describe command('sysctl -a') do
    its(:stdout) { should include('kernel.sched_child_runs_first') }
  end
end

describe file('/usr/share/travis/system_info') do
  it { should exist }
  its(:size) { should be_positive }
end

describe file('/var/ramfs'), docker: false do
  it { should be_mounted.with(type: 'tmpfs') }
end

describe 'travis_build_environment packages' do
  Support.base_packages.each do |package_name|
    describe(package(package_name)) { it { should be_installed } }
  end
end

describe user('travis') do
  it { should exist }
  it { should have_home_directory '/home/travis' }
  it { should have_login_shell '/bin/bash' }
end

describe file('/home/travis/bin') do
  it { should be_directory }
  it { should be_writable }
end

def test_txt
  Support.tmpdir.join('test.txt')
end

describe 'unarchivers installation' do
  describe command('gzip --version') do
    its(:stdout) { should match(/^gzip \d/) }
    its(:exit_status) { should eq 0 }
  end

  # XXX: Figure out why this test hangs. Disabling for now.
  # describe command('bzip2 --version') do
  #   its(:stderr) { should match(/^bzip.*Version \d/) }
  #   its(:exit_status) { should eq 0 }
  # end

  describe command('zip --version') do
    its(:stdout) { should match(/Zip \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('unzip -version') do
    its(:stdout) { should match(/^UnZip \d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('dpkg -s libbz2-dev') do
    its(:stdout) { should match 'Status: install ok installed' }
  end

  before :each do
    test_txt.write("Konstantin broke all the things.\n")
  end

  describe command(
    %(
      gzip #{test_txt};
      rm #{test_txt};
      ls #{Support.tmpdir};
      gzip -d #{test_txt}.gz;
      cat #{test_txt}
    )
  ) do
    its(:stdout) { should include('test.txt.gz') }
    its(:stdout) { should match 'Konstantin broke all the things.' }
  end

  describe command(
    %(
      bzip2 -z #{test_txt};
      rm #{test_txt};
      ls #{Support.tmpdir};
      bzip2 -d #{test_txt}.bz2;
      cat #{test_txt}
    )
  ) do
    its(:stdout) { should include('test.txt.bz2') }
    its(:stdout) { should match 'Konstantin broke all the things.' }
  end

  describe command(
    %(
      cd #{Support.tmpdir};
      zip test.zip test.txt;
      rm test.txt;
      ls #{Support.tmpdir};
      unzip test.zip;
      cat test.txt
    )
  ) do
    its(:stdout) { should include('test.zip') }
    its(:stdout) { should match 'Konstantin broke all the things.' }
  end
end

describe 'emacs installation' do
  describe command('emacs --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'editing' do
    before do
      test_txt.write("daisy\n")
      sh(%(emacs -batch #{test_txt} --eval '(insert \"poof\")' -f save-buffer))
    end

    describe file(test_txt) do
      its(:content) { should match 'poof' }
    end
  end
end

describe 'vim installation' do
  describe command('vim --version') do
    its(:stdout) { should_not be_empty }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end

  before do
    test_txt.write("their\n")
    sh("vim #{test_txt} -c s/their/there -c wq")
  end

  describe file(test_txt) do
    its(:content) { should match(/there/) }
  end
end

describe command('lsof -v 2>&1 | head -2 | tail -1') do
  its(:stdout) { should match(/revision:/) }
  its(:exit_status) { should eq 0 }
end

describe command('iptables --version') do
  its(:stdout) { should include 'iptables' }
  its(:exit_status) { should eq 0 }
end

describe command('curl --version | head -1') do
  its(:stdout) { should include 'curl' }
  its(:exit_status) { should eq 0 }
end

describe command('wget --version') do
  its(:stdout) { should include 'GNU Wget' }
  its(:exit_status) { should eq 0 }
end

describe command('rsync --version') do
  its(:stdout) { should match(/rsync.+version/) }
  its(:exit_status) { should eq 0 }
end

describe command('nc -h') do
  its(:exit_status) { should eq 0 }
end

describe command('ldconfig -V') do
  its(:stdout) { should include 'ldconfig ' }
  its(:exit_status) { should eq 0 }
end

describe command('ldconfig -p | grep libldap') do
  its(:stdout) { should match(/libldap_r/) }
  its(:exit_status) { should eq 0 }
end

context 'with something listening on 19494' do
  around :each do |example|
    pid = spawn(
      'python', '-m', 'SimpleHTTPServer', '19494',
      %i[out err] => '/dev/null'
    )
    tcpwait('127.0.0.1', 19_494)
    example.run
    Process.kill(:TERM, pid)
  end

  describe command('nc -zv 127.0.0.1 19494') do
    stream = if RbConfig::CONFIG['build_os'] =~ /darwin/
               :stdout
             else
               :stderr
             end
    its(stream) { should include 'succeeded' }
  end
end

describe file('/opt') do
  it { should be_directory }
  it { should be_writable }
end

describe file('/etc/hosts'), docker: false do
  let :lines do
    subject.content.split("\n").map(&:strip).reject do |line|
      line =~ /^\s*#/ || line.empty?
    end
  end

  %w[127.0.0.1 127.0.1.1].each do |ipv4_addr|
    it "has one #{ipv4_addr} entry" do
      expect(lines.grep(/^\s*#{ipv4_addr}\b/).length).to eq(1)
    end
  end

  {
    '127.0.0.1' => 'localhost',
    '127.0.1.1' => 'ip4-loopback'
  }.each do |addr, name|
    it "maps #{addr} to #{name}" do
      expect(lines.grep(/^\s*#{addr}\b/).first.split(/\s+/)).to include(name)
    end
  end
end

describe 'disabled ipv6', docker: false do
  describe command('ip addr') do
    its(:stdout) { should_not match(/\binet6\s+.+::.+scope\s+link/) }
  end

  describe file('/etc/hosts') do
    its(:content) { should_not match(/::1.+\blocalhost\b/) }
  end
end
