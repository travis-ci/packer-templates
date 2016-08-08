describe command('bats --version'), precise: false do
  its(:stdout) { should match(/^Bats \d/) }
end
