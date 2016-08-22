require 'image_metadata'
require 'env'

describe ImageMetadata do
  let(:env) { Env.new }
  let(:tarball) { 'somedir/metadata.tar.bz2' }

  subject do
    described_class.new(tarball: tarball, env: env)
  end

  it 'constructs an image extraction command' do
    expect(subject.send(:extract_command)).to eq(
      [
        'tar', '-C', 'somedir', '-xjvf',
        File.expand_path('somedir/metadata.tar.bz2')
      ]
    )
  end
end
