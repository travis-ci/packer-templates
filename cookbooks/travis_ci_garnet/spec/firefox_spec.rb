describe 'firefox installation' do
  describe command('firefox -v') do
    its(:exit_status) { should eq 0 }
  end

  describe 'firefox commands' do
    before do
      sh('DISPLAY=:99.0 firefox -CreateProfile test')
    end

    describe file('/home/travis/.mozilla/firefox/profiles.ini') do
      its(:content) { should match(/^Name=test/) }
    end
  end
end
