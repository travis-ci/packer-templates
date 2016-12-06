describe command('psql --version') do
  its(:stdout) { should match(/^psql.+9\.[2-6]+\.[0-9]+/) }
  its(:exit_status) { should eq 0 }
end
