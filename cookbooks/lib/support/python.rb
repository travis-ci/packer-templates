module Support
  module Python
    def pycommand(cmd)
      command("#{source_virtualenv_activate} ; #{cmd}")
    end

    def source_virtualenv_activate
      return @sva if @sva
      venv_activate = File.expand_path('~/virtualenv/python2.7/bin/activate')
      @sva = 'true'
      @sva = "source #{venv_activate}" if File.exist?(venv_activate)
      @sva
    end
  end
end
