describe service('docker'), legacy: false do
  it { should be_enabled }
  it { should be_running }
end

describe service('travis-worker') do
  it { should be_enabled }
  it { should be_running }
end
