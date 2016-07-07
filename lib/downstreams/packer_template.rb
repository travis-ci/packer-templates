require 'forwardable'

module Downstreams
  class PackerTemplate
    extend Forwardable

    def initialize(filename, string)
      @name = File.basename(filename.sub(/.*::/, ''), '.yml')
      @filename = filename
      @parsed = Downstreams::YamlLoader.load_string(string)
    end

    attr_reader :name, :filename, :parsed

    def_delegators :@parsed, :[], :each
  end
end
