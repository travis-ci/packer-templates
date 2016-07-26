describe file('/.node-attributes.yml'), dev: true do
  it { should exist }
  its(:content_as_yaml) { should include('__timestamp') }
end
