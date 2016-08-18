describe 'xserver installation' do
  describe command('Xorg -version') do
    its(:exit_status) { should eq 0 }
  end

  describe command('DISPLAY=:99.0 xset -q') do
    its(:stdout) { should match(/^Keyboard Control:/) }
    its(:exit_status) { should eq 0 }
  end

  describe command('xvfb-run -a xdpyinfo'), dev: true do
    its(:stdout) { should match(/^\s+GLX$/) }
    its(:stderr) { should be_empty }
    its(:exit_status) { should eq 0 }
  end
end
