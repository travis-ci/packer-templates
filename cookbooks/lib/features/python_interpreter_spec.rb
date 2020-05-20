# frozen_string_literal: true

%w[
  python
  python3
].each do |py|
  describe "#{py} interpreter" do
    describe command("#{py} --version") do
      stream = :stderr.empty? ? :stdout : :stderr
      its(stream) { should match(/^Python \d+\.\d+\.\d+/) }
    end

    describe command("#{py} -m this") do
      its(:stderr) { should be_empty }
      its(:stdout) { should match(/Readability counts\./) }
    end
  end
end
