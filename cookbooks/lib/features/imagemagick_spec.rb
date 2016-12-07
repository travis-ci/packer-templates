describe 'imagemagick installation' do
  describe command('convert --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/imagemagick/i) }
  end

  describe 'imagemagick commands' do
    before do
      logo_gif = Support.tmpdir.join('logo.gif')
      logo_gif.unlink if logo_gif.exist?
      sh("convert logo: #{logo_gif}")
    end

    describe command("identify #{Support.tmpdir.join('logo.gif')}") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/logo\.gif GIF/) }
    end
  end
end
