describe 'elasticsearch installation', sudo: true do
  before :all do
    sh('sudo service elasticsearch start')
    tcpwait('localhost', 9200, 30)
    sh('curl -X PUT \'http://localhost:9200/twitter/user/kimchy\' ' \
       '-d \'{ "name" : "Shay Banon" }\'')
    sh(
      'curl -X PUT \'http://localhost:9200/twitter/tweet/1\' ' \
      '-d \' { "user": "kimchy", "postDate": "2009-11-15T13:12:00", ' \
      '"message": "Trying out Elasticsearch" }\''
    )
    sleep 8
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe command(
    "curl -X GET 'http://localhost:9200/twitter/tweet/1?pretty=true'"
  ) do
    its(:stdout) { should include('Trying out Elasticsearch') }
  end

  describe command(
    "curl -X GET 'http://localhost:9200/twitter/tweet/_search?q=message:Trying&pretty=true'"
  ) do
    its(:stdout) { should match(/"total"\s*:\s*1/) }
    its(:stdout) { should match(/"user"\s*:\s*"kimchy"/) }
    its(:stdout) { should match(/"message"\s*:\s*"Trying out Elasticsearch"/) }
  end
end
