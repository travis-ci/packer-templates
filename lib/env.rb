require 'forwardable'

class Env
  extend Forwardable

  def initialize(base: ENV)
    @state = Hash[base]
  end

  def [](key)
    (state[key] || '').strip
  end

  def_delegators :@state, :[]=, :key?, :clear, :to_hash

  def load_envdir(path)
    Dir.glob(File.join(path, '*')) do |entry|
      next unless File.file?(entry)
      key = File.basename(entry)
      value = File.read(entry).strip
      yield [key, value] if block_given?
      state[key] = value
    end
  end

  private

  attr_reader :state
end
