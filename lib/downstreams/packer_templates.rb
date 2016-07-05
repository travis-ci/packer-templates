require 'find'

module Downstreams
  class PackerTemplates
    def self.load(packer_templates_path)
      inst = new
      inst.load(packer_templates_path)
      inst
    end

    def initialize
      @templates_by_name = {}
    end

    def each(&block)
      @templates_by_name.each(&block)
    end

    def load(packer_templates_path)
      packer_template_files(packer_templates_path).each do |filename|
        template = PackerTemplate.new(filename)
        @templates_by_name[template.name] = template
      end
    end

    private

    def packer_template_files(packer_templates_path)
      packer_templates_path.map do |packer_templates_dir|
        Dir.glob(File.join(packer_templates_dir, '*.yml')).select do |f|
          packer_template?(f)
        end
      end.flatten.compact.sort
    end

    def packer_template?(filename)
      parsed = Downstreams::YamlLoader.load(filename)
      %w(variables builders provisioners).all? { |k| parsed.include?(k) }
    rescue => e
      $stderr.puts "ERROR: #{e}\n#{e.backtrace.join("\n")}"
      false
    end
  end
end
