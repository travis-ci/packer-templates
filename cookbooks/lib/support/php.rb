module Support
  module Php
    def phpcommand(cmd)
      command("#{phpenv_exec} #{cmd}")
    end

    def phpenv_exec
      return @phpenv_exec if @phpenv_exec
      available = `phpenv versions 2>/dev/null`.strip
      php_versions.each do |v|
        next if @phpenv_exec
        @phpenv_exec = "RBENV_VERSION=#{v} phpenv exec" if available =~ /\b#{v}\b/
      end
      @phpenv_exec ||= ''
      @phpenv_exec
    end

    def php_versions
      php_versions_trusty || php_versions_precise || %w(system)
    end

    def php_versions_trusty
      ::Support.attributes
               .fetch('travis_build_environment', {})['php_versions']
    end

    def php_versions_precise
      ::Support.attributes
               .fetch('php', {})
               .fetch('multi', {})['versions']
    end
  end
end
