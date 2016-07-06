require 'find'

module Downstreams
  class PackerTemplates
    def initialize(packer_templates_path)
      @packer_templates_path = packer_templates_path
    end

    def each(&block)
      templates_by_name.each(&block)
    end

    private

    attr_reader :packer_templates_path

    def templates_by_name
      @templates_by_name ||= load_templates_by_name
    end

    def load_templates_by_name
      loaded = {}

      packer_template_files.each do |filename|
        template = PackerTemplate.new(filename)
        loaded[template.name] = template
      end

      loaded
    end

    def packer_template_files
      packer_templates_path.map do |entry|
        entry.files(/.*\.yml$/).map { |f, _| f }.select do |f|
          packer_template?(entry.repo.show('HEAD', f))
        end
      end.flatten.compact.sort
    end

    def packer_template?(file_contents)
      parsed = Downstreams::YamlLoader.load_string(file_contents)
      %w(variables builders provisioners).all? { |k| parsed.include?(k) }
    rescue => e
      $stderr.puts "ERROR: #{e}\n#{e.backtrace.join("\n")}"
      false
    end
  end
end
