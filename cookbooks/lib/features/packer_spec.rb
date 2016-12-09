describe command('packer version'), precise: false do
  its(:stdout) { should match(/^Packer v\d/) }
  its(:exit_status) { should eq 0 }
end
