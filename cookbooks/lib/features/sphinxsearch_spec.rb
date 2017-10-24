# frozen_string_literal: true

describe 'sphinx installation' do
  describe command('searchd') do
    its(:stdout) { should match 'Sphinx' }
  end

  Dir.glob('/usr/local/sphinx-*/bin/indexer') do |indexer|
    describe command(indexer) do
      its(:stdout) { should match(/Sphinx /) }
    end
  end
end
