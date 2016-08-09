require 'job_board_registrar'

def tmpdir
  @tmpdir ||= Dir.mktmpdir(%w(packer-templates job-board-register))
end

describe JobBoardRegistrar do
  subject do
    described_class.new(image_metadata_tarball)
  end

  let :image_metadata_tarball do
    File.join(tmpdir, 'metadata.tar.bz2')
  end

  let :image_metadata_dir do
    File.join(tmpdir, 'metadata')
  end

  before :each do
    rm_rf(tmpdir)
    mkdir_p(tmpdir)
    system(%W(
      tar -C #{tmpdir} -cjf #{image_metadata_tarball} #{image_metadata_dir}
    ).join(' '))
  end
end
