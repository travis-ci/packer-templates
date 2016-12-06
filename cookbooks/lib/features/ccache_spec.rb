describe 'ccache installation' do
  describe command('ccache -V') do
    its(:exit_status) { should eq 0 }
  end

  describe 'ccache commands are executed' do
    describe command('ccache -s') do
      its(:stdout) do
        should include(
          'cache directory',
          'cache hit',
          'cache miss',
          'files in cache',
          'max cache size'
        )
      end
    end

    describe command('ccache -M 0.5') do
      its(:stdout) { should match 'Set cache size limit to 512.0 Mbytes' }
    end
  end
end
