describe 'system_info exist', mega: true, standard: true, minimal: true do
  describe command('test -f /usr/share/travis/system_info') do
    its(:exit_status) { should eq 0 }
  end
end
