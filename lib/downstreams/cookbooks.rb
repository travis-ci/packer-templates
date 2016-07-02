require 'find'

module Downstreams
  class Cookbooks
    def self.load(cookbook_path)
      inst = new
      inst.load(cookbook_path)
      inst
    end

    def initialize
      @cookbook_files = {}
    end

    def load(cookbook_path)
      cookbook_path.each do |cookbooks_dir|
        Dir.foreach(cookbooks_dir) do |f|
          if File.exist?(File.join(cookbooks_dir, f, 'metadata.rb'))
            @cookbook_files[f] = load_files(File.join(cookbooks_dir, f))
          end
        end
      end
    end

    def files(cookbook)
      @cookbook_files[cookbook]
    end

    private

    def load_files(cookbook)
      Find.find(cookbook).select { |f| File.file?(f) }
    end
  end
end
