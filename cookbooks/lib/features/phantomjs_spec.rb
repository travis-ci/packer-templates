# frozen_string_literal: true

def test_js
  Support.tmpdir.join('test.js')
end

describe 'phantomjs installation' do
  before do
    test_js.write(<<-EOF.gsub(/^\s+> /, ''))
      > var page = require('webpage').create();
      > page.open('http://www.google.com', function(status) {
      >   console.log("Status: " + status);
      >   phantom.exit();
      > });
    EOF
  end

  describe command('phantomjs -v') do
    its(:stdout) { should match(/\d/) }
    its(:exit_status) { should eq 0 }
  end

  describe command("phantomjs #{test_js}") do
    its(:stdout) { should match 'Status: success' }
  end
end
