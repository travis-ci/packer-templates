require 'packer_manifest'

describe PackerManifest do
  let(:test_filename) do
    File.expand_path('../../tmp/spec-packer-manifest.json', __FILE__)
  end

  let(:manifest_content) do
    {
      builds: [
        {
          name: 'flub',
          builder_type: 'bogus',
          files: [
            {
              name: '/foo/bar/deeply/nested/wat/whippit',
              size: 2
            },
            {
              name: '/var/tmp/whyyy/vroom',
              size: 8
            }
          ]
        },
        {
          name: 'bork',
          builder_type: 'bogus',
          files: nil
        }
      ]
    }
  end

  subject { described_class.new(filename: test_filename) }

  before do
    File.write(test_filename, JSON.dump(manifest_content))
  end

  it 'can be loaded' do
    expect(subject).to_not be_nil
  end

  it 'allows for finding files' do
    expect(subject.find(/nope/)).to be_empty
    expect(subject.find(/whip/)).to eq ['/foo/bar/deeply/nested/wat/whippit']
    expect(subject.find(/./).length).to eq 2
  end
end
