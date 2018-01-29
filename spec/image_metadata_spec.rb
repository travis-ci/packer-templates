# frozen_string_literal: true

require 'image_metadata'
require 'env'
require 'support'

include Support

describe ImageMetadata do
  let(:env) { Env.new }
  let(:tarball) { 'somedir/metadata.tar.bz2' }
  let(:attrs) { job_board_attrs }

  subject do
    described_class.new(tarball: tarball, env: env)
  end

  before do
    allow(subject).to receive(:image_job_board_env_exists?)
      .and_return(true)
    allow(subject).to receive(:job_board_register_hash)
      .and_return(job_board_attrs)
  end

  it 'constructs an image extraction command' do
    expect(subject.send(:extract_command)).to eq(
      [
        'tar', '-C', 'somedir', '-xjf',
        File.expand_path('somedir/metadata.tar.bz2')
      ]
    )
  end

  it 'loads job board register yml into the env' do
    subject.send(:load_job_board_register_yml)
    expect(env['OS']).to eq(attrs['tags']['os'])
    expect(env['DIST']).to eq(attrs['tags']['dist'])
    expect(env['TAGS']).to eq(attrs['tags_string'])
  end

  it 'loads metadata from the expected sources' do
    expect(subject).to receive(:load_job_board_register_yml)
    expect(subject).to receive(:extract_tarball)
    expect(subject).to receive(:load_image_metadata)
    expect(env).to receive(:to_hash)
    subject.load!
  end
end
