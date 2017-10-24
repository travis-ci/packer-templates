# frozen_string_literal: true

def furbies
  @furbies ||= rand(200..299)
end

describe 'neo4j installation' do
  describe command('which neo4j') do
    its(:stdout) { should match 'bin/neo4j' }
  end

  describe 'neo4j commands' do
    before :all do
      sh('service neo4j start')
      tcpwait('127.0.0.1', 1337, 30)
      sh("neo4j-shell -v -c 'create (n:thing {furbies: #{furbies}});'")
    end

    describe command("neo4j-shell -v -c 'cd 0 && ls'") do
      its(:stdout) { should include('furbies =', furbies.to_s) }
      its(:stderr) { should match 'Picked up _JAVA_OPTIONS: -Xmx2048m -Xms512m\n' }
    end
  end
end
