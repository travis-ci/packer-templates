# frozen_string_literal: true

describe 'perl installation' do
  describe command('perlbrew list --verbose') do
    its(:stdout) { should match(/5\.\d+(\.\d)?\s+\(installed on .+\)?/) }
  end

  describe command('cpanm --quiet --version </dev/null') do
    its(:stdout) { should match(/cpanm \(App::cpanminus\) version \d+\.\d+/) }
  end
end
