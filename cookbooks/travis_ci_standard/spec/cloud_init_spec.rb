describe ppa('pollinate/ppa') do
  it { should exist }
  it { should be_enabled }
end

describe package('pollinate') do
  it { should be_installed }
end

describe file('/etc/cloud/templates') do
  it { should be_directory }
end

describe file('/etc/cloud/cloud.cfg') do
  its(:content) { should match(/managed by chef/i) }
  its(:content) { should match(/travis_build_environment/i) }
end

%w(
  /etc/cloud/templates/hosts.debian.tmpl
  /etc/cloud/templates/hosts.tmpl
  /etc/cloud/templates/hosts.ubuntu.tmpl
).each do |filename|
  describe file(filename) do
    it { should be_exist }
    its(:content) { should match(/\$hostname/) }
    its(:content) { should match(/\$fqdn/) }
    its(:content) { should match(/managed by chef/i) }
    its(:content) { should match(/travis_build_environment/i) }
  end
end

%w(
  /etc/cloud/templates/sources.list.debian.tmpl
  /etc/cloud/templates/sources.list.tmpl
  /etc/cloud/templates/sources.list.ubuntu.tmpl
).each do |filename|
  describe file(filename) do
    its(:content) { should match(/managed by chef/i) }
    its(:content) { should match(/travis_build_environment/i) }
  end
end
