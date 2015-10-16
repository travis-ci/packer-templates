module Support
  module Helpers
    def tcpwait(host, port, timeout = 10)
      require 'socket'

      now = Time.now

      loop do
        begin
          TCPSocket.new(host, port)
          break
        rescue Errno::ECONNREFUSED => e
          raise e if (Time.now - now >= timeout)
          sleep 0.1
        end
      end
    end
  end
end
