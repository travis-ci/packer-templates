module Support
  module Python
    def pycommand(cmd)
      command("#{source_virtualenv_activate} ; #{cmd}")
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
      python_versions_trusty || python_versions_precise || %w(2.7)
    end

    def python_versions_trusty
      ::Support.attributes
               .fetch('travis_python', {})
               .fetch('pyenv', {})['pythons']
    end

    def python_versions_precise
      ::Support.attributes
               .fetch('python', {})
               .fetch('pyenv', {})['pythons']
    end
  end
end
