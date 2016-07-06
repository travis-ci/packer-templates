require 'downstreams'

describe Downstreams::ChefCookbooks do
  let(:fake_cookbook_path_entry) { double('fake_cookbook_path_entry') }
  let :cookbook_metadata_files do
    %w(
      cookbooks/bytecoind/metadata.rb
    ).map { |f| Downstreams::GitPath.new(nil, f) }
  end

  let :cookbook_bytecoind_files do
    %w(
      cookbooks/bytecoind/metadata.rb
      cookbooks/bytecoind/recipes/default.rb
      cookbooks/bytecoind/attributes/default.rb
    ).map { |f| Downstreams::GitPath.new(nil, f) }
  end

  subject do
    described_class.new([fake_cookbook_path_entry])
  end

  before :each do
    allow(fake_cookbook_path_entry).to receive(:files)
      .with(%r{.+/metadata\.rb$}).and_return(cookbook_metadata_files)
    allow(fake_cookbook_path_entry).to receive(:files)
      .with(%r{cookbooks/bytecoind/.+}).and_return(cookbook_bytecoind_files)
  end

  it 'lazily loads cookbook files' do
    expect(subject.files('bytecoind')).to eq(cookbook_bytecoind_files)
  end

  it 'returns an empty array for unknown cookbooks' do
    expect(subject.files('blokus')).to eq([])
  end
end
