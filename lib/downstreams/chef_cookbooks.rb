require 'find'

module Downstreams
  class ChefCookbooks
    def initialize(cookbook_path)
      @cookbook_path = cookbook_path
    end

    def files(cookbook)
      cookbook_files.fetch(cookbook, [])
    end

    private

    attr_reader :cookbook_path

    def cookbook_files
      @cookbook_files ||= load_all_cookbook_files
    end

    def load_all_cookbook_files
      loaded = {}

      cookbook_path.each do |entry|
        entry.files(%r{.+/metadata\.rb$})
             .map { |p| File.dirname(p) }.uniq.each do |prefix|
          loaded[File.basename(prefix)] = entry.files(%r{#{prefix}/.+})
        end
      end

      loaded
    end
  end
end
