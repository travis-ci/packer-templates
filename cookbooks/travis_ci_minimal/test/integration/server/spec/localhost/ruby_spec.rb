describe 'ruby installation' do
  describe command('ruby -v') do
    its(:stdout) { should match(/^ruby /) }
    its(:exit_status) { should eq 0 }
  end

  describe command(%(ruby -e 'puts RUBY_ENGINE')) do
    its(:stdout) { should match(/^ruby/) }
  end

  describe command(%(ruby -e 'puts "Konstanin broke all the things!"')) do
    its(:stdout) { should match(/^Konstanin broke all the things!$/) }
  end
end
