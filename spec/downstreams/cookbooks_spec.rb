require 'downstreams'

describe Downstreams::ChefCookbooks do
  let :cookbook_dir_entries do
    %w(
      bytecoind
      spec
      lib
    )
  end

  let :cookbook_files do
    %w(
      bytecoind/metadata.rb
      bytecoind/recipes/default.rb
      bytecoind/files/default/random.seed
      bytecoind/templates/default/confy.conf
    )
  end

  before :each do
    allow(Dir).to receive(:foreach) do |&block|
      cookbook_dir_entries.each(&block)
    end
    allow(File).to receive(:exist?) do |f|
      f == 'somewhere/bytecoind/metadata.rb'
    end
    allow(File).to receive(:file?) do |f|
      cookbook_files.include?(f)
    end
    allow(Find).to receive(:find).with('somewhere/bytecoind')
      .and_return(cookbook_files)
  end

  it 'may be loaded via .load' do
    inst = described_class.load(%w(somewhere))
    expect(inst.files('bytecoind')).to_not be_empty
  end

  it 'may be loaded via #load' do
    subject.load(%w(somewhere))
    expect(subject.files('bytecoind')).to_not be_empty
  end

  it 'is empty after initialization' do
    expect(subject.files('bytecoind')).to be_empty
  end

  it 'returns an empty array for unknown cookbooks' do
    subject.load(%w(somewhere))
    expect(subject.files('blokus')).to eq([])
  end
end
