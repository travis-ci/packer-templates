require 'yaml'
require 'erb'

module Downstreams
  class YamlLoader
    def self.load(filename)
      YAML.load(ERB.new(File.read(filename)).result)
    end
  end
end
