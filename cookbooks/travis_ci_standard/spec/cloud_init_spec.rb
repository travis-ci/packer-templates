describe file('/etc/cloud/templates') do
  it { should be_directory }
end

describe file('/etc/cloud/templates/hosts.tmpl') do
  it { should be_exist }
  its(:content) { should match(/\$hostname/) }
  its(:content) { should match(/\$fqdn/) }
end
