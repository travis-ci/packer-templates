def hello_java
  Support.tmpdir.join('Hello.java')
end

describe 'jdk installation' do
  describe command('java -version') do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should match(/^java/) }
  end

  describe file('/opt/jdk_switcher/jdk_switcher.sh') do
    it { should exist }
    it { should be_readable }
  end

  describe command(%(
    . /opt/jdk_switcher/jdk_switcher.sh;
    jdk_switcher home default
  )) do
    its(:stdout) { should match(%r{/usr/lib/jvm}) }
    its(:exit_status) { should eq 0 }
  end

  it 'should have JAVA_HOME defined' do
    expect(ENV['JAVA_HOME']).to_not be_nil
    expect(ENV['JAVA_HOME']).to_not be_empty
  end

  describe 'java command' do
    before do
      hello_java.write(<<-EOF.gsub(/\s+> /, ''))
        > class Hello
        > {
        >   public static void main ( String[] args )
        >   {
        >     System.out.println("Hello World!");
        >   }
        > }
      EOF
      Dir.chdir(Support.tmpdir) { sh('javac Hello.java') }
    end

    describe command("cd #{Support.tmpdir} && java Hello") do
      its(:stdout) { should match 'Hello World!' }
    end
  end
end
