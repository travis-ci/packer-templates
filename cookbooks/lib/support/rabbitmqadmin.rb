module Support
  class RabbitMQAdmin
    def exe
      ensure_available!
      dest
    end

    def ensure_available!
      return if dest.exist? && dest.executable?
      download_rabbitmqadmin
    end

    private

    def download_rabbitmqadmin
      system "curl -sSL -o #{dest} #{url}"
      dest.chmod(0o0755)
    end

    def dest
      Pathname.new(
        ENV['RABBITMQADMIN_DEST'] || Support.tmpdir.join('rabbitmqadmin')
      )
    end

    def url
      ENV['RABBITMQADMIN_URL'] ||
        'http://hg.rabbitmq.com/rabbitmq-management/raw-file/tip/bin/rabbitmqadmin'
    end
  end
end
