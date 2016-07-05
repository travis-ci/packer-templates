module Downstreams
  class ChefPackerTemplate
    def initialize(filename)
      @name = File.basename(filename, '.yml')
      @filename = filename
    end

    attr_reader :name, :filename
  end
end
