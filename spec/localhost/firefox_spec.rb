describe 'firefox installation', mega: :todo, standard: true do
  describe command('firefox -v') do
    its(:exit_status) { should eq 0 }
  end

  describe 'firefox commands' do
    describe command(%w(firefox -CreateProfile test --display=DISPLAY=:99.0 ;
                        cat ~/.mozilla/firefox/profiles.ini).join(' ')) do
      its(:stdout) { should match 'Name=test' }
    end
  end
end
