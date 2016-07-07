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
      remotes.select { |r| r.name == 'origin' }.first.url
    end

    def show(ref = default_ref, show_path = path)
      @show_at ||= {}
      unless @show_at.fetch(ref, {}).fetch(show_path, nil)
        @show_at[ref] ||= {}
        @show_at[ref][show_path] = repo.show(ref, show_path)
      end
      @show_at[ref][show_path]
    end

    def files(matching = /.*/, ref = default_ref)
      files = files_at(ref)
      matching_files = files.map { |p, _| p }.select do |p|
        p =~ /^#{path}/ && p =~ matching
      end

      matching_files.map do |f|
        Downstreams::GitPath.new(repo, f, ref)
      end
    end

    private

    def remotes
      @remotes ||= repo.remotes
    end

    def files_at(ref = default_ref)
      @files_at ||= {}
      unless @files_at[ref]
        repo.with_temp_working do
          repo.checkout(ref)
          @files_at[ref] = repo.ls_files
        end
      end
      @files_at[ref]
    end
  end
end
