require 'find'

module Downstreams
  class ChefCookbooks
    def initialize(cookbook_path)
      @cookbook_path = cookbook_path
      @cookbook_files = {}
    end

    def populate!
      cookbook_path.each do |cookbooks_dir|
        Dir.foreach(cookbooks_dir) do |f|
          if File.exist?(File.join(cookbooks_dir, f, 'metadata.rb'))
            @cookbook_files[f] = load_files(File.join(cookbooks_dir, f))
          end
        end
      end
      self
    end

    def files(cookbook)
      @cookbook_files.fetch(cookbook, [])
    end

    private

    attr_reader :cookbook_path

    def load_files(cookbook)
      Find.find(cookbook).select { |f| File.file?(f) }
    end
  end
end
