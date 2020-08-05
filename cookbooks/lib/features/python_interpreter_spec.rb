# frozen_string_literal: true

shared_examples 'Readability counts' do |py|
  describe command("#{py} -m this") do
    its(:stderr) { should be_empty }
    its(:stdout) { should match(/Readability counts\./) }
  end
end

describe 'python2 interpreter' do
  include_examples 'Readability counts', 'python'

  describe 'python --version' do
    cmd = command('python --version')
    results = cmd.stderr.to_s == '' ? cmd.stdout.to_s : cmd.stderr.to_s

    specify { expect(results).to match(/^Python \d+\.\d+\.\d+/) }
  end
end

describe 'python3 interpreter' do
  include_examples 'Readability counts', 'python3'

  describe 'python3 --version' do
    cmd = command('python3 --version')
    results = cmd.stderr.to_s == '' ? cmd.stdout.to_s : cmd.stderr.to_s

    specify { expect(results).to match(/^Python \d+\.\d+\.\d+/) }
  end
end
