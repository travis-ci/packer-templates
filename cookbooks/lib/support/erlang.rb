module Support
  module Erlang
    def erlcommand(cmd)
      command("#{source_activate} ; #{cmd}")
    end

    def source_activate
      return @sa if @sa
      candidate_erlang_versions.each do |version|
        next if @sa
        activate = File.expand_path("~/otp/#{version}/bin/activate")
        @sa = "source #{activate}" if File.exist?(activate)
      end
      @sa ||= 'true'
      @sa
    end

    def candidate_erlang_versions
      (
        ENV['TRAVIS_CANDIDATE_ERLANG_VERSIONS'] || '18.2 R16B03'
      ).split.map(&:strip)
    end
  end
end
