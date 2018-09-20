# frozen_string_literal: true

module Support
  module Python
    def pycommand(cmd, version: nil)
      return command("#{source_virtualenv_activate} ; #{cmd}") if version.nil?

      activate = File.expand_path("~/virtualenv/#{version}/bin/activate")
      command("source #{activate}; #{cmd}")
    end

    def source_virtualenv_activate
      return @sva if @sva

      python_versions.each do |v|
        next if @sva

        activate = File.expand_path("~/virtualenv/python#{v}/bin/activate")
        @sva = "source #{activate}" if File.exist?(activate)
      end
      @sva ||= 'true'
      @sva
    end

    def python_versions
      python_versions_trusty || %w[2.7]
    end

    def python_versions_trusty
      ::Support.attributes
               .fetch('travis_build_environment', {})['pythons']
    end
  end
end
