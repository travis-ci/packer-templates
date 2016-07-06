module Downstreams
  class GitPath
    def initialize(repo, path, default_ref = 'HEAD')
      @repo = repo
      @path = path
      @default_ref = default_ref
    end

    attr_reader :repo, :path, :default_ref

    def namespaced_path
      "#{origin_url}::#{path}"
    end

    def origin_url
      repo.remotes.select { |r| r.name == 'origin' }.first.url
    end

    def show(ref = default_ref, show_path = path)
      repo.show(ref, show_path)
    end

    def files(matching = /.*/, ref = default_ref)
      files = {}

      repo.with_temp_working do
        repo.checkout(ref)
        files.merge!(repo.ls_files)
      end

      matching_files = files.map { |p, _| p }.select do |p|
        p =~ /^#{path}/ && p =~ matching
      end

      matching_files.map do |f|
        Downstreams::GitPath.new(repo, f, ref)
      end
    end
  end
end
