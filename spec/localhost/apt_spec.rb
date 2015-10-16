describe 'apt installation', mega: true, standard: true, minimal: true do
  before :all do
    system('sudo apt-get update -yqq', [:out, :err] => '/dev/null')
  end

  describe command('apt-get -v') do
    its(:exit_status) { should eq 0 }
  end

  describe 'apt commands', sudo: true do
    describe command('sudo apt-get update -y') do
      its(:stdout) { should match(/http/) }
    end

    describe command('sudo apt-get install -y language-pack-pt') do
      its(:stdout) { should match(/Setting up /) }
    end
  end
end
