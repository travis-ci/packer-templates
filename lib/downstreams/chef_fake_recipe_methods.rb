require 'tmpdir'

module Downstreams
  module ChefFakeRecipeMethods
    def include_recipe(name)
      @included_recipes ||= []
      @included_recipes << name
    end

    %w(
      apt_repository
      bash
      cookbook_file
      directory
      dpkg_package
      execute
      git
      group
      link
      package
      remote_file
      ruby_block
      service
      template
      user
    ).each { |m| define_method(m) { |*| } }

    def node
      @node ||= ForeverHash.new
    end

    module Chef
      class Config
        def self.file_cache_path
          Dir.tmpdir
        end
      end
    end

    class ForeverHash < Hash
      def [](key)
        self[key] = ForeverHash.new unless key?(key)
        fetch(key)
      end
    end
  end
end
