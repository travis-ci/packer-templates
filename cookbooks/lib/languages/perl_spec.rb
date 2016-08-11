describe 'perl installation', dev: true do
  describe command('perlbrew list') do
    its(:stdout) { should match(/\* 5\.\d+ \(5\.\d+\.\d+\)/) }
  end

  describe command('cpanm --version') do
    its(:stdout) { should match(/cpanm \(App::cpanminus\) version \d+\.\d+/) }
  end
end
