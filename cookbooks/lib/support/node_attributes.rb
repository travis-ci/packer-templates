# frozen_string_literal: true

require 'yaml'

module Support
  class NodeAttributes
    def initialize(yml: yml_file)
      @yml = yml
    end

    def load
      permitted = [Symbol]
      permitted << ChefUtils::VersionString if defined?(ChefUtils::VersionString)

      YAML.safe_load(
        File.read(yml),
        permitted_classes: permitted,
        aliases: true
      )
    end

    private

    attr_reader :yml

    def yml_file
      ENV.fetch('NODE_ATTRIBUTES_YML', '/.node-attributes.yml')
    end
  end
end
