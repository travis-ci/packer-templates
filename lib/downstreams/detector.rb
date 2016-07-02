require 'English'
require 'find'
require 'thread'
require 'yaml'

module Downstreams
  class Detector
    def initialize(cookbooks_dir, packer_templates_dir)
      @cookbooks_dir = cookbooks_dir
      @packer_templates_dir = packer_templates_dir
    end

    def detect(filenames)
      # * walk the @packer_templates_dir, get list of packer templates
      # * for each packer template, if it contains a chef-solo provisioner,
      #   read the members of the run_list
      # * for each member of the run_list, evaluate/read the relevant
      #   recipe, looking for `include_recipe`.
      # * follow the `include_recipe` bits until (condition??)
      # * if a git commit path is inside a found cookbook, then append
      #   the affected template to a list (which is returned later)
      to_trigger = []
      filenames.map! { |f| f.gsub(%r{^[./]+}, '') }

      packer_templates.each do |template, run_list_cookbooks|
        run_list_cookbooks.each do |cb|
          cb_files = Array(cookbooks.files(cb))
          next if cb_files.empty?
          to_trigger << template unless (filenames & cb_files).empty?
        end
      end

      to_trigger
    end

    private

    attr_reader :cookbooks_dir, :packer_templates_dir

    def packer_templates
      @packer_templates ||= PackerTemplates.load(
        [cookbooks_dir], packer_templates_dir
      )
    end

    def cookbooks
      @cookbooks ||= Cookbooks.load(cookbooks_dir)
    end
  end
end

exit(LilChef.hacketytest!) if $PROGRAM_NAME == __FILE__
