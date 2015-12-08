describe file('/var/ramfs'), docker: false do
  it { should be_mounted.with(type: 'tmpfs') }
end
