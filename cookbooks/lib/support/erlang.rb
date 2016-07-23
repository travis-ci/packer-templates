module Support
  module Erlang
    def erlcommand(cmd)
      command("#{source_activate} ; #{cmd}")
    end

    def source_activate
      return @sa if @sa
      activate = File.expand_path('~/otp/18.2/bin/activate')
      @sa = 'true'
      @sa = "source #{activate}" if File.exist?(activate)
      @sa
    end
  end
end
