# frozen_string_literal: true

require 'yaml'

module Support
  class NodeAttributes
    def initialize(yml: yml_file)
      @yml = yml
    end

    def load
      YAML.safe_load(File.read(yml))
    end

    private

    attr_reader :yml

    def yml_file
      ENV.fetch('NODE_ATTRIBUTES_YML', '/.node-attributes.yml')
    end
  end
end
