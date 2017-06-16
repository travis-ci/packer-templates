# frozen_string_literal: true

describe 'firefox installation' do
  describe command('firefox -v') do
    its(:exit_status) { should eq 0 }
  end

  describe 'firefox commands' do
    before do
      Support.tmpdir.join('.mozilla/firefox').mkpath
      sh("HOME=#{Support.tmpdir} DISPLAY=:99.0 firefox -CreateProfile test")
    end

    describe file(
      Support.tmpdir.join('.mozilla/firefox/profiles.ini')
    ) do
      its(:content) { should match(/^Name=test/) }
    end
  end
end
