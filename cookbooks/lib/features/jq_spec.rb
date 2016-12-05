def test_json
  Support.tmpdir.join('test.json')
end

describe 'jq installation' do
  before do
    test_json.write(<<-EOF.gsub(/^\s+> /, ''))
      > {
      >   "stuff": [
      >     {
      >       "@type": "smarm",
      >       "msg": [
      >         "Konstantin broke all the things"
      >       ]
      >     },
      >     {
      >       "@type": "empty"
      >     }
      >   ]
      > }
    EOF
  end

  describe command('jq -V') do
    its(:exit_status) { should eq 0 }
  end

  describe command(
    %(jq -r '.stuff|.[]|select(."@type"=="smarm")|.msg[0]' <#{test_json})
  ) do
    its(:stdout) { should match(/^Konstantin broke all the things/) }
  end
end
