# frozen_string_literal: true

describe 'perl interpreter' do
  describe command('perl --version') do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/perl 5, version \d/) }
  end

  describe command(%q(perl -e 'print "Hello Mr Euler!\n"')) do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/^Hello Mr Euler!/) }
  end
end
