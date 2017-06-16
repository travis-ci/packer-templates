# frozen_string_literal: true

describe 'nodejs interpreter' do
  describe command('node -v') do
    its(:stdout) { should match(/v\d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('node -e "console.log(\'Konstantin broke all the thingz\')"') do
    its(:stdout) { should match 'Konstantin broke all the thingz' }
  end
end
