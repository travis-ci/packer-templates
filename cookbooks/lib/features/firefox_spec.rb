# frozen_string_literal: true

describe 'firefox installation' do
  describe command('sudo -u travis firefox -v') do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should be_empty }
  end

  describe 'firefox commands' do
    before do
      home = Support.tmpdir
      profile = home.join('.mozilla/firefox')
      profile.mkpath

      sh("chown --recursive travis:travis #{home}")
      sh("HOME=#{home} DISPLAY=:99.0 sudo -u travis firefox -CreateProfile test")
    end

    describe file(
      Support.tmpdir.join('.mozilla/firefox/profiles.ini')
    ) do
      its(:content) { should match(/^Name=test/) }
      it { should exist }
    end
  end
end
