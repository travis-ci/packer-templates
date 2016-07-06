module Downstreams
  class GitPath
    def initialize(repo, path, default_ref = 'HEAD')
      @repo = repo
      @path = path
      @default_ref = default_ref
    end

    attr_reader :repo, :path, :default_ref

    def show(ref = default_ref, show_path = path)
      repo.show(ref, show_path)
    end

    def files(matching = /.*/)
      files = {}

      repo.with_temp_working do
        repo.checkout
        files.merge!(repo.ls_files)
      end

      files.map { |p, _| p }.select do |p|
        p =~ /^#{path}/ && p =~ matching
      end
    end
  end
end
