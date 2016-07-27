describe 'maven installation' do
  describe command('mvn -version') do
    its(:exit_status) { should eq 0 }
  end

  describe command('mvn help:describe -Dplugin=help') do
    its(:stdout) { should match 'Name: Maven Help Plugin' }
  end
end
