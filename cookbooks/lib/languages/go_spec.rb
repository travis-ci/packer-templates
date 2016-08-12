require 'features/go_toolchain_spec'

describe 'go installation', dev: true do
  describe command('gimme -l') do
    its(:stdout) { should match(/^1\.6\.3$/) }
  end
end
