require 'tmpdir'

module Downstreams
  module FakeRecipeMethods
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

    module Chef
      class Config < Hash
        def self.file_cache_path
          Dir.tmpdir
        end
      end
    end
  end
end
