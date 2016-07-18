describe command('bats --version') do
  its(:stdout) { should match(/^Bats \d/) }
end
