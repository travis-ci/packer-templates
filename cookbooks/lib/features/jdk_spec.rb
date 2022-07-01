# frozen_string_literal: true

def hello_java
  Support.tmpdir.join('Hello.java')
end

def java_installer
  return 'jdk_switcher' if File.file?('/opt/jdk_switcher/jdk_switcher.sh')
  return 'install_jdk' if File.file?('/usr/local/bin/install-jdk.sh')

  false
end

describe 'jdk installation' do
  describe command('java -version') do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should match(/^(java|openjdk)/) }
  end

  if java_installer == 'jdk_switcher'
    describe command(%(
      . /opt/jdk_switcher/jdk_switcher.sh;
      jdk_switcher home default
    )) do
      its(:stdout) { should match(%r{/usr/lib/jvm}) }
      its(:exit_status) { should eq 0 }
    end
  end

  it 'should have JAVA_HOME defined' do
    expect(ENV['JAVA_HOME']).to_not be_nil
    expect(ENV['JAVA_HOME']).to_not be_empty
  end

  describe 'java command' do
    before do
      hello_java.write(<<~EOF)
        class Hello {
          public static void main (String[] args) {
            System.out.println("Hello World!");
          }
        }
      EOF
      Dir.chdir(Support.tmpdir) { sh('javac Hello.java') }
    end

    describe command("cd #{Support.tmpdir} && java Hello") do
      its(:stdout) { should match 'Hello World!' }
    end
  end
end
