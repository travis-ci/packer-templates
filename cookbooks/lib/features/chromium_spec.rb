# frozen_string_literal: true

if os[:arch] !~ /ppc64/
  describe 'chromium installation' do
    describe package('chromium-browser') do
      it { should be_installed }
    end

    describe command('chromium-browser --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
