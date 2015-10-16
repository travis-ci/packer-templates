describe 'maven installation', mega: true, standard: true do
  describe command('mvn -version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'maven commands' do
    describe command('mvn help:describe -Dplugin=help; sleep 5') do
      its(:stdout) { should match 'Name: Maven Help Plugin' }
    end
  end
end
