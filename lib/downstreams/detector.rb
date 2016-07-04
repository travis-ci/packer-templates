require 'English'
require 'find'
require 'thread'
require 'yaml'

module Downstreams
  class Detector
    def initialize(cookbooks_path, packer_templates_path)
      @cookbooks_path = cookbooks_path
      @packer_templates_path = packer_templates_path
    end

    def detect(filenames)
      to_trigger = []
      filenames.map! { |f| File.expand_path(f) }

      packer_templates.each do |template, run_list_cookbooks|
        to_trigger << template.name if filenames.include?(template.filename)

        run_list_cookbooks.each do |cb|
          cb_files = Array(cookbooks.files(cb))
          next if cb_files.empty?
          to_trigger << template.name unless (filenames & cb_files).empty?
        end
      end

      to_trigger.sort.uniq
    end

    private

    attr_reader :cookbooks_path, :packer_templates_path

    def packer_templates
      @packer_templates ||= PackerTemplates.load(
        cookbooks_path, packer_templates_path
      )
    end

    def cookbooks
      @cookbooks ||= Cookbooks.load(cookbooks_path)
    end
  end
end
