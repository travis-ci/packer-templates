module Support
  module Erlang
    def erlcommand(cmd)
      command("#{source_activate} ; #{cmd}")
    end

    def source_activate
      return @sa if @sa
      otp_releases.each do |version|
        next if @sa
        activate = File.expand_path("~/otp/#{version}/bin/activate")
        @sa = "source #{activate}" if File.exist?(activate)
      end
      @sa ||= 'true'
      @sa
    end

    def otp_releases
      otp_releases_trusty || otp_releases_precise || %w(18.2 17.5 R16B03)
    end

    def otp_releases_trusty
      ::Support.attributes.fetch('travis_build_environment', {})['otp_releases']
    end

    def otp_releases_precise
      ::Support.attributes.fetch('kerl', {})['releases']
    end
  end
end
