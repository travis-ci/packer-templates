describe 'elasticsearch installation' do
  before :all do
    system('sudo service elasticsearch start')
    sleep 5
    system(
      'curl -X GET http://localhost:9200/',
      [:out, :err] => '/dev/null'
    )
    sleep 8
    system(
      'curl -X PUT \'http://localhost:9200/twitter/user/kimchy\' ' \
      '-d \'{ "name" : "Shay Banon" }\'',
      [:out, :err] => '/dev/null'
    )
    system(
      'curl -X PUT \'http://localhost:9200/twitter/tweet/1\' ' \
      '-d \' { "user": "kimchy", "postDate": "2009-11-15T13:12:00", ' \
      '"message": "Trying out Elasticsearch" }\'',
      [:out, :err] => '/dev/null'
    )
    sleep 8
  end

  describe package('elasticsearch') do
    it { should be_installed }
  end

  describe 'elasticsearch start', sudo: true do
    describe command('curl -XGET \'http://localhost:9200/twitter/tweet/1?pretty=true\'') do
      its(:stdout) { should include('Trying out Elasticsearch') }
    end

    describe command('curl -XGET \'http://localhost:9200/twitter/tweet/_search?q=message:Trying&pretty=true\'') do
      its(:stdout) { should include('"total" : 1', '"user": "kimchy"', '"message": "Trying out Elasticsearch"') }
    end
  end
end
