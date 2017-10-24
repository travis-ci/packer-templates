# frozen_string_literal: true

describe 'perlbrew installation' do
  describe command('perlbrew --version') do
    its(:stdout) do
      should match(
        %r{perl5/perlbrew/bin/perlbrew.+App::perlbrew\/\d+\.\d+}
      )
    end
    its(:exit_status) { should eq 0 }
  end

  describe command('perlbrew list') do
    its(:exit_status) { should eq 0 }
  end
end
