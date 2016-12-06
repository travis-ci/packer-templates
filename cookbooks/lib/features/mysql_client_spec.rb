describe command('mysql --version') do
  its(:stdout) { should match(/^mysql /) }
  its(:exit_status) { should eq 0 }
end
