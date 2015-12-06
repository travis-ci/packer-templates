describe 'sudoers setup' do
  before do
    RSpec.configure do |c|
      set :shell, '/tmp/sudo-bash'
    end
  end

  after do
    RSpec.configure do |c|
      set :shell, '/bin/bash'
    end
  end

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
    %w(authenticate env_reset mail_badpass).each do |disabled|
      its(:content) { should match(/^Defaults !#{disabled}$/) }
    end
  end
end
