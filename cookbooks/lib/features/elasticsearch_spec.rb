describe 'elasticsearch installation', sudo: true do
  before :all do
    sh('sudo service elasticsearch start')
    tcpwait('localhost', 9200, 30)
    sh('curl -X PUT \'http://localhost:9200/travis/user/koopa93\' ' \
       '-d \'{"name":"Shy Bowser"}\'')
    sh(
      'curl -X PUT \'http://localhost:9200/travis/toot/1\' ' \
      '-d \'{"user":"koopa93","postDate":"2009-11-15T13:12:00",' \
      '"message":"Frying up Elastosearch"}\''
    )
    sleep 8
  end

  after :all do
    sh('curl -X DELETE \'http://localhost:9200/travis\'')
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe command(
    "curl -X GET 'http://localhost:9200/travis/toot/1?pretty=true'"
  ) do
    its(:stdout) { should include('Frying up Elastosearch') }
  end

  describe command(
    'curl -X GET ' \
    '"http://localhost:9200/travis/toot/_search?q=message:Frying&pretty=true"'
  ) do
    its(:stdout) { should match(/"total"\s*:\s*1/) }
    its(:stdout) { should match(/"user"\s*:\s*"koopa93"/) }
    its(:stdout) { should match(/"message"\s*:\s*"Frying up Elastosearch"/) }
  end
end
