require 'job_board_registrar'

describe JobBoardRegistrar do
  context 'with file operations stubbed out' do
    let :image_metadata_tarball do
      'somedir/metadata.tar.bz2'
    end

    subject do
      described_class.new(image_metadata_tarball)
    end

    before :each do
      ENV.clear
      {
        IMAGE_NAME: 'travis-ci-foo-flah-99999999999',
        JOB_BOARD_IMAGES_URL: 'http://flim:flam@job-board.example.org/images',
        TRAVIS_COOKBOOKS_BRANCH: 'master',
        CURL_EXE: ':'
      }.each do |key, value|
        ENV[key.to_s] = value
      end
      allow(subject).to receive(:load_envdir).with('somedir/job-board-env')
      allow(File).to receive(:exist?).with('somedir/metadata.tar.bz2').and_return(true)
      allow(File).to receive(:directory?).with('somedir/metadata/env').and_return(true)
      allow(subject).to receive(:load_envdir).with('somedir/metadata/env')
      allow(subject).to receive(:extract_image_metadata_tarball).and_return(true)
      subject.send(:logger).level = Logger::FATAL
    end

    it 'registers an image' do
      expect(subject).to receive(:make_request).once
      subject.register!
    end
  end

  context 'with real commands' do
    xit 'eventually maybe'
  end
end
