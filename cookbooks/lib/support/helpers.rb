# frozen_string_literal: true

module Support
  module Helpers
    def docker?
      File.exist?('/.dockerenv')
    end

    def tcpwait(host, port, timeout = 10)
      require 'socket'
      now = Time.now
      loop { break if tcpwait_tick(host, port, now, timeout) }
    end

    def procwait(proc_pattern, timeout = 10)
      now = Time.now

      loop do
        procs = `ps aux`.split(/\n/).map(&:strip)
        break if procs.grep(proc_pattern).any?
        raise TimesUp if Time.now - now >= timeout
        sleep 0.1
      end
    end

    def sh(command, out = '/dev/null', err = '/dev/null')
      system(command, 1 => out, 2 => err)
    end

    TimesUp = Class.new(StandardError)

    private def tcpwait_tick(host, port, now, timeout)
      TCPSocket.new(host, port)
      return true
    rescue Errno::ECONNREFUSED, Errno::EINVAL => e
      raise e if Time.now - now >= timeout
      sleep 0.1
      false
    end
  end
end
