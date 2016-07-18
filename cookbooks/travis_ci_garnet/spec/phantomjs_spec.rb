describe 'phantomjs installation' do
  describe command('phantomjs -v') do
    its(:stdout) { should match(/\d/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'phantomjs commands' do
    describe command('phantomjs ./spec/files/phantomjs_test_google.js') do
      its(:stdout) { should match 'Status: success' }
    end
  end
end
