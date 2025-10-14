# frozen_string_literal: true

describe 'perlbrew installation' do
  describe command('perlbrew --version') do
    its(:stdout) do
      should match(
        %r{(?:/[\w/]+)?perlbrew\s+-\s+App::perlbrew/\d+\.\d+}
      )
    end
    its(:exit_status) { should eq 0 }
  end

  describe command('perlbrew list') do
    its(:stdout) { should match(/perl|5\.\d+/) } # sanity check: list has versions
    its(:exit_status) { should eq 0 }
  end
end
