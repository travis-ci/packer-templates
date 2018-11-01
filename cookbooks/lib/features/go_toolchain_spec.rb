# frozen_string_literal: true

def go_source
  Support.tmpdir.join('example.go')
end

def randint
  @randint ||= rand(10_000..20_000)
end

describe 'go toolchain installation' do
  describe command('go version') do
    its(:stdout) { should match(/^go version go/) }
  end

  describe command('go env GOROOT') do
    its(:stdout) { should match(%r{/\.gimme/}) }
  end

  describe 'compiling something' do
    before do
      go_source.write(<<-EOF.gsub(/^\s+> ?/, ''))
        > package main
        > import "fmt"
        > func main() {
        >   fmt.Println("Good morrow, #{randint}")
        > }
      EOF
    end

    describe command("go run #{go_source}") do
      its(:stdout) { should match(/Good morrow, #{randint}/) }
    end
  end
end
