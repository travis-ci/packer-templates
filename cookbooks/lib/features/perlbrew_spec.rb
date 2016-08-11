describe 'perlbrew installation' do
  describe command('perlbrew --version') do
    its(:stdout) do
      should match(
        %r{perl5/perlbrew/bin/perlbrew.+App::perlbrew\/\d+\.\d+}
      )
    end
  end

  describe command('perlbrew list') do
    its(:stdout) { should match(/\* 5\.\d+ \(5\.\d+\.\d+\)/) }
  end
end
