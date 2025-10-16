# frozen_string_literal: true

module Support
  module Php
    def phpcommand(cmd)
      command("#{php_exec_prefix} #{cmd}")
    end

    def php_exec_prefix
      return @php_exec_prefix if @php_exec_prefix

      if system('command -v phpenv >/dev/null 2>&1')
        unless php_default_version.empty?
          @php_exec_prefix = "PHPENV_VERSION=#{php_default_version} phpenv exec"
          return @php_exec_prefix
        end

        available = `phpenv versions 2>/dev/null`.strip
        php_versions.each do |v|
          next if @php_exec_prefix
          @php_exec_prefix = "PHPENV_VERSION=#{v} phpenv exec" if available =~ /\b#{v}\b/
        end
      end

      @php_exec_prefix ||= 'php'
      @php_exec_prefix
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
