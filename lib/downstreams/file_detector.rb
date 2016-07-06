module Downstreams
  class FileDetector
    def initialize(packer_templates_path)
      @packer_templates_path = packer_templates_path
    end

    def detect(filenames)
      to_trigger = []

      packer_templates.each do |_, template|
        to_trigger << template.name if filenames.include?(template.filename)
        to_trigger << template.name unless (
          provisioner_files(template['provisioners'] || []) & filenames
        ).empty?
      end

      to_trigger.sort.uniq
    end

    private

    attr_reader :packer_templates_path

    def packer_templates
      @packer_templates ||= PackerTemplates.new(packer_templates_path)
    end

    def provisioner_files(provisioners)
      files = provisioners.select { |p| p['type'] == 'file' }.map do |p|
        packer_templates_path.map do |entry|
          entry.files(/#{p['source']}/) || nil
        end
      end
      files.flatten.compact.sort.uniq
    end
  end
end
