def md5deep_txt
  Support.tmpdir.join('md5deep.txt')
end

describe 'md5deep installation' do
  before do
    md5deep_txt.write("Konstantin broke all the things in m5deep!\n")
  end

  describe command('md5deep -v') do
    its(:exit_status) { should eq 0 }
  end

  describe command('md5deep -V') do
    its(:stdout) { should match 'This program is a work of the US Government.' }
  end

  describe command("md5deep #{md5deep_txt}") do
    its(:stdout) { should match(/^29c04665afa6ef18edc38824ceaff6ab\b/) }
  end
end
