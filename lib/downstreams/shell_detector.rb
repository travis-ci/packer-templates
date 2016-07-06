module Downstreams
  class ShellDetector
    def initialize(packer_templates_path)
      @packer_templates_path = packer_templates_path
    end

    def detect(git_paths)
      filenames = git_paths.map(&:namespaced_path)
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
      shell_provisioners = provisioners.select do |p|
        p['type'] == 'shell' && (p.key?('scripts') || p.key?('script'))
      end

      script_files = shell_provisioners.map do |p|
        Array(p['scripts']) + Array(p['script'])
      end

      script_files.flatten!
      script_files.map! do |f|
        packer_templates_path.map do |entry|
          matching_files = entry.files(/#{f}/)
          matching_files.empty? ? nil : matching_files
        end
      end

      script_files.flatten.compact.map(&:namespaced_path).sort.uniq
    end
  end
end
