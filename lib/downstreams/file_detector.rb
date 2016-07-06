module Downstreams
  class FileDetector
    def initialize(packer_templates_path, git_working_copy)
      @packer_templates_path = packer_templates_path
      @git_working_copy = git_working_copy
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

    attr_reader :packer_templates_path, :git_working_copy

    def packer_templates
      @packer_templates ||= PackerTemplates.new(packer_templates_path).populate!
    end

    def provisioner_files(provisioners)
      provisioners.select { |p| p['type'] == 'file' }
                  .map { |p| File.expand_path(p['source'], git_working_copy) }
    end
  end
end
