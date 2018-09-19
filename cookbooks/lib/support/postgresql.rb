# frozen_string_literal: true

module Support
  module Postgresql
    def pgcommand(cmd, version: nil)
      return command("#{pg_path} #{cmd}") if version.nil?

      command("PATH=/usr/lib/postgresql/#{version}/bin:$PATH #{cmd}")
    end

    def pg_path
      return @pg_path if @pg_path

      pg_versions.each do |v|
        next if @pg_path

        bindir = "/usr/lib/postgresql/#{v}/bin"
        @pg_path = "PATH=#{bindir}:$PATH" if File.exist?(bindir)
      end
      @pg_path ||= ''
      @pg_path
    end

    def pg_versions
      ::Support.attributes
               .fetch('postgresql', {})
               .fetch('alternate_versions', %w[9.2 9.3 9.4 9.5 9.6])
    end
  end
end
