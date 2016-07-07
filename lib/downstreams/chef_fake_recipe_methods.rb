require 'tmpdir'

module Downstreams
  module ChefFakeRecipeMethods
    def include_recipe(name)
      @included_recipes ||= []
      @included_recipes << name
    end

    %w(
      ark
      apt_repository
      bash
      collectd_plugin
      cookbook_file
      data_bag
      directory
      dpkg_package
      execute
      fail
      file
      git
      group
      link
      log
      mount
      mysql_service
      package
      packagecloud_repo
      platform
      raise
      remote_directory
      remote_file
      ruby_block
      script
      service
      template
      travis_python_pip
      user
    ).each { |m| define_method(m) { |*, &block| } }

    def node
      @node ||= ForeverHash.new
    end

    class TravisPackerTemplates
      def initialize(*)
      end

      def init!
      end
    end

    def const_missing(*)
      BlackHole
    end

    class BlackHole
      def initialize(*)
      end

      def method_missing(*)
      end
    end

    module Chef
      class Config
        def self.[](key)
          @config ||= ForeverHash.new
          @config[key]
        end

        def self.file_cache_path
          Dir.tmpdir
        end
      end

      Log = Class.new(BlackHole)
      VersionConstraint = Class.new(BlackHole)
      Recipe = Class.new(BlackHole)
    end

    class ForeverHash < Hash
      def [](key)
        self[key] = ForeverHash.new unless key?(key)
        fetch(key)
      end

      def method_missing(key)
        self[key]
      end
    end
  end
end
