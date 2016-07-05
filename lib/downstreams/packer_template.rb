require 'forwardable'

module Downstreams
  class PackerTemplate
    extend Forwardable

    def initialize(filename)
      @name = File.basename(filename, '.yml')
      @filename = filename
      @parsed = Downstreams::YamlLoader.load(filename)
    end

    attr_reader :name, :filename, :parsed

    def_delegators :@parsed, :[], :each
  end
end
