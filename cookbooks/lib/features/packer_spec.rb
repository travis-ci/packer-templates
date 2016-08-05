describe 'packer installation', precise: false do
  describe command('packer version') do
    its(:stdout) { should match(/^Packer v\d/) }
    its(:exit_status) { should eq 0 }
  end
end
