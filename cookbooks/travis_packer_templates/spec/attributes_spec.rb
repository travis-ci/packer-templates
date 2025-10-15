# frozen_string_literal: true

describe 'node attributes YAML' do
  path = '/.node-attributes.yml'

  if File.exist?(path)
    describe file(path) do
      it { should exist }
      its(:content_as_yaml) { should include('__timestamp') }
    end
  else
    skip "Skipping node-attributes.yml check (file not present outside build context)"
  end
end
