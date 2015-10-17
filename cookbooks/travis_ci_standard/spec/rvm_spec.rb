describe file(::File.expand_path('~/.rvm/user/db')) do
  it { should exist }
  it { should be_writable }
  it { should be_readable }
end
