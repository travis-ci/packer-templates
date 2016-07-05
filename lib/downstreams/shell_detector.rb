module Downstreams
  class ShellDetector
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
      @packer_templates ||= PackerTemplates.load(packer_templates_path)
    end

    def provisioner_files(provisioners)
      provisioners.select do |p|
        p['type'] == 'shell' &&
          (p.key?('scripts') || p.key?('script'))
      end
                  .map { |p| Array(p['scripts']) + Array(p['script']) }
                  .flatten
                  .map { |f| File.expand_path(f, git_working_copy) }
    end
  end
end
