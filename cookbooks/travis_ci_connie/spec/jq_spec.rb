describe 'jq installation' do
  describe command('jq -V') do
    its(:exit_status) { should eq 0 }
  end

  describe 'jq command' do
    describe command('cat ./spec/files/jq.json | jq ".[0] | {message: .commit.message, name: .commit.committer.name}"') do
      its(:stdout) { should match '{\n  \"message\": \"Konstantin broke all the things.\",\n  \"name\": \"Tyranja\"\n}\n' }
    end
  end
end
