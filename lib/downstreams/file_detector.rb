module Downstreams
  class FileDetector
    def initialize(packer_templates_path, log)
      @packer_templates_path = packer_templates_path
      @log = log
    end

    def detect(git_paths)
      filenames = git_paths.map(&:namespaced_path)
      to_trigger = []

      packer_templates.each do |_, template|
        log.info "Detecting type=file template=#{template.name}"
        to_trigger << template.name if filenames.include?(template.filename)
        to_trigger << template.name unless (
          provisioner_files(template['provisioners'] || []) & filenames
        ).empty?
      end

      to_trigger.sort.uniq
    end

    private

    attr_reader :packer_templates_path, :log

    def packer_templates
      @packer_templates ||= PackerTemplates.new(packer_templates_path)
    end

    def provisioner_files(provisioners)
      files = provisioners.select { |p| p['type'] == 'file' }.map do |p|
        packer_templates_path.map do |entry|
          matching_files = entry.files(/#{p['source']}/)
          matching_files.empty? ? nil : matching_files
        end
      end
      files.flatten.compact.map(&:namespaced_path).sort.uniq
    end
  end
end
