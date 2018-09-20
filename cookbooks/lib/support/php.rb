# frozen_string_literal: true

module Support
  module Php
    def phpcommand(cmd)
      command("#{phpenv_exec} #{cmd}")
    end

    def phpenv_exec
      return @phpenv_exec if @phpenv_exec

      unless php_default_version.empty?
        @phpenv_exec = "PHPENV_VERSION=#{php_default_version} phpenv exec"
        return @phpenv_exec
      end

      available = `phpenv versions 2>/dev/null`.strip
      php_versions.each do |v|
        next if @phpenv_exec

        @phpenv_exec = "PHPENV_VERSION=#{v} phpenv exec" if available =~ /\b#{v}\b/
      end
      @phpenv_exec ||= ''
      @phpenv_exec
    end

    def php_versions
      php_versions_trusty || %w[5.6.13 system]
    end

    def php_versions_trusty
      ::Support.attributes
               .fetch('travis_build_environment', {})['php_versions']
    end

    def php_default_version
      php_default_version_trusty || ''
    end

    def php_default_version_trusty
      ::Support.attributes
               .fetch('travis_build_environment', {})['php_default_version']
    end
  end
end
