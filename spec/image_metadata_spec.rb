require 'image_metadata'
require 'env'

describe ImageMetadata do
  let(:env) { Env.new }
  let(:tarball) { 'somedir/metadata.tar.bz2' }

  subject do
    described_class.new(tarball: tarball, env: env)
  end

  before do
    allow(subject).to receive(:image_job_board_env_exists?)
      .and_return(true)
  end

  it 'constructs an image extraction command' do
    expect(subject.send(:extract_command)).to eq(
      [
        'tar', '-C', 'somedir', '-xjvf',
        File.expand_path('somedir/metadata.tar.bz2')
      ]
    )
  end

  it 'loads metadata from the expected sources' do
    expect(env).to receive(:source_file)
    expect(subject).to receive(:extract_tarball)
    expect(subject).to receive(:load_image_metadata)
    expect(env).to receive(:to_hash)
    subject.load!
  end
end
