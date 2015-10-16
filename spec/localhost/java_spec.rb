describe 'java installation', mega: true, standard: true do
  describe command('java -version') do
    its(:exit_status) { should eq 0 }
  end

  it 'should have JAVA_HOME defined' do
    expect(ENV['JAVA_HOME']).to_not be_nil
    expect(ENV['JAVA_HOME']).to_not be_empty
  end

  describe 'java command' do
    before do
      system('cd ./spec/files && javac Hello.java')
    end

    describe command('cd ./spec/files && java Hello') do
      its(:stdout) { should match 'Hello World!' }
    end
  end
end
