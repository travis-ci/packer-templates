# frozen_string_literal: true

module Support
  module Erlang
    def erlcommand(cmd)
      command("#{source_activate} ; #{cmd}")
    end

    def source_activate
      return @sa if @sa

      otp_releases.sort { |a, b| a.delete('R') <=> b.delete('R') }
                  .reverse_each do |version|
        next if @sa

        activate = File.expand_path("~/otp/#{version}/activate")
        @sa = "source #{activate}" if File.exist?(activate)
      end
      @sa ||= 'true'
      @sa
    end

    def otp_releases
      otp_releases_trusty || %w[18.2 17.5 R16B03]
    end

    def otp_releases_trusty
      ::Support.attributes.fetch('travis_build_environment', {})['otp_releases']
    end
  end
end
