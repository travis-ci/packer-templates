describe 'elasticsearch installation', standard: true do
  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe 'elasticsearch start', sudo: true do
    before :all do
      system('sudo service elasticsearch start')
      system('sleep 5')
      system('curl -X GET http://localhost:9200/')
      system('sleep 8')
      system('curl -XPUT \'http://localhost:9200/twitter/user/kimchy\' -d \'{ "name" : "Shay Banon" }\'')
      system('curl -XPUT \'http://localhost:9200/twitter/tweet/1\' -d \' { "user": "kimchy", "postDate": "2009-11-15T13:12:00", "message": "Trying out Elasticsearch" }\'')
      system('sleep 8')
    end

    describe command('curl -XGET \'http://localhost:9200/twitter/tweet/1?pretty=true\'') do
      its(:stdout) { should include('Trying out Elasticsearch') }
    end

    describe command('curl -XGET \'http://localhost:9200/twitter/tweet/_search?q=message:Trying&pretty=true\'') do
      its(:stdout) { should include('"total" : 1', '"user": "kimchy"', '"message": "Trying out Elasticsearch"') }
    end
  end
end
