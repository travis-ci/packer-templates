# frozen_string_literal: true

describe file('/.node-attributes.yml') do
  it { should exist }
  its(:content_as_yaml) { should include('__timestamp') }
end
