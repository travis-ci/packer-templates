require 'find'
require 'yaml'

module Downstreams
  class ChefPackerTemplates
    def initialize(cookbook_path, packer_templates_path)
      @cookbook_path = cookbook_path
      @packer_templates_path = packer_templates_path
      @cookbooks_by_template = {}
    end

    def each(&block)
      @cookbooks_by_template.each(&block)
    end

    def populate!
      PackerTemplates.new(packer_templates_path).populate!.each do |_, t|
        parsed = Downstreams::YamlLoader.load(t.filename)
        Array(parsed['provisioners']).each do |provisioner|
          next unless provisioner['type'] =~ /chef/
          next if Array(provisioner.fetch('run_list', [])).empty?
          key = ChefPackerTemplate.new(t.filename)
          @cookbooks_by_template[key] = Downstreams::ChefDependencyFinder.new(
            provisioner['run_list'], cookbook_path
          ).find
        end
      end
      self
    end

    private

    attr_reader :cookbook_path, :packer_templates_path
  end
end
