# frozen_string_literal: true

# Xenial has google-chrome deprecated - to do
if %w[xenial].include?(Support.distro)
  'google-chrome package has deprecated for Xenial'
else
  describe 'google-chrome installation' do
    describe package('google-chrome-stable') do
      it { should be_installed }
    end

    describe command('google-chrome --version') do
      its(:exit_status) { should eq 0 }
    end
  end
end
