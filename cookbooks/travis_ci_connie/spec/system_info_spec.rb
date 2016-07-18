describe 'system_info exist' do
  describe command('test -f /usr/share/travis/system_info') do
    its(:exit_status) { should eq 0 }
  end
end
