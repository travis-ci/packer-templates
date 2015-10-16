describe 'imagemagick installation', mega: true, standard: true, minimal: true do
  describe command('convert --version') do
    its(:exit_status) { should eq 0 }
  end

  describe 'imagemagick commands' do
    before do
      system('convert logo: logo.gif')
    end

    describe command('identify logo.gif') do
      its(:exit_status) { should eq 0 }
    end
  end
end
