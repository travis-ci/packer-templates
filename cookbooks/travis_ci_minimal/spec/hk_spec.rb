describe command('hk version') do
  its(:stdout) { should match(/^20140604$/) }
end
