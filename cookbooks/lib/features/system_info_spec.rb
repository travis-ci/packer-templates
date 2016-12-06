describe file('/usr/share/travis/system_info') do
  it { should exist }
  its(:size) { should be > 0 }
end
