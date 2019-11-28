# frozen_string_literal: true

def db_url
  'http://localhost:9200/travis'
end

describe 'elasticsearch installation', sudo: true do
  describe package('elasticsearch') do
    it { should be_installed }
  end

  before :all do
    sh('sudo service elasticsearch restart')
    sleep 5
    tcpwait('localhost', 9200, 30)
    sh(%(curl -H "Content-Type: application/json" -X PUT "#{db_url}/user/koopa93" -d "{
        \"name\": \"Shy Bowser\"
      }"
    ))
    sh(%(curl -H "Content-Type: application/json" -X PUT "#{db_url}/toot/1" -d "{
        \"user\": \"koopa93\",
        \"postDate\": \"2009-11-15T13:12:00\",
        \"message\": \"Frying up Elastosearch\"
      }"
    ))
    sleep 8
  end

  after :all do
    sh(%(curl -H "Content-Type: application/json" -X DELETE "#{db_url}"))
  end
end
