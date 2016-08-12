require 'support'

def go_source
  File.join(Support.tmpdir, 'example.go')
end

def randint
  @randint ||= rand(10_000..20_000)
end

describe 'go toolchain installation', dev: true do
  describe command('go version') do
    its(:stdout) { should match(/^go version go1\.[4567]/) }
  end

  describe command('go env GOROOT') do
    its(:stdout) { should match(%r{/\.gimme/}) }
  end

  describe 'compiling something' do
    before do
      File.open(go_source, 'w') do |f|
        f.puts <<-EOF.gsub(/^\s+> ?/, '')
          > package main
          > import "fmt"
          > func main() {
          >   fmt.Println("Good morrow, #{randint}")
          > }
        EOF
      end
    end

    describe command("go run #{go_source}") do
      its(:stdout) { should match(/Good morrow, #{randint}/) }
    end
  end
end
