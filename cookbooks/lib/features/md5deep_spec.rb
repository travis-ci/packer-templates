describe 'md5deep installation' do
  describe command('md5deep -v') do
    its(:exit_status) { should eq 0 }
  end

  describe command('md5deep -V') do
    its(:stdout) { should match 'This program is a work of the US Government.' }
  end

  describe command("md5deep #{Support.libdir}/features/files/md5deep.txt") do
    its(:stdout) { should match(/^29c04665afa6ef18edc38824ceaff6ab\b/) }
  end
end
