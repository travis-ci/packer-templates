# frozen_string_literal: true

require 'forwardable'

class Env
  extend Forwardable

  def initialize(base: ENV)
    @state = Hash[base]
  end

  def [](key)
    (state[key] || '').strip
  end

  def_delegators :@state, :[]=, :key?, :clear, :to_hash, :fetch

  def load_envdir(path)
    Dir.glob(File.join(path, '*')) do |entry|
      next unless File.file?(entry)

      key = File.basename(entry)
      value = File.read(entry).strip
      yield [key, value] if block_given?
      state[key] = value
    end
  end

  attr_reader :state
  private :state
end
