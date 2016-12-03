describe 'jq installation' do
  describe command('jq -V') do
    its(:exit_status) { should eq 0 }
  end

  describe command(
    "cat #{Support.libdir}/features/files/jq.json | " \
    'jq -r ".[0] | .commit.message"'
  ) do
    its(:stdout) { should match(/^Konstantin broke all the things/) }
  end
end
