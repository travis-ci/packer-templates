module Support
  class RabbitMQAdmin
    def exe
      ensure_available!
      dest
    end

    def ensure_available!
      return if File.exist?(dest) && File.executable?(dest)
      download_rabbitmqadmin
    end

    private

    def download_rabbitmqadmin
      system "curl -sSL -o #{dest} #{url}"
      FileUtils.chmod(0755, dest)
    end

    def dest
      ENV['RABBITMQADMIN_DEST'] || File.join(Support.libdir, 'rabbitmqadmin')
    end

    def url
      ENV['RABBITMQADMIN_URL'] ||
        'http://hg.rabbitmq.com/rabbitmq-management/raw-file/tip/bin/rabbitmqadmin'
    end
  end
end
