describe 'java installation' do
  describe command('java -version') do
    its(:exit_status) { should eq 0 }
  end

  it 'should have JAVA_HOME defined' do
    expect(ENV['JAVA_HOME']).to_not be_nil
    expect(ENV['JAVA_HOME']).to_not be_empty
  end

  describe 'java command' do
    before do
      Dir.chdir("#{Support.libdir}/languages/files") { sh('javac Hello.java') }
    end

    describe command("cd #{Support.libdir}/languages/files && java Hello") do
      its(:stdout) { should match 'Hello World!' }
    end
  end
end
