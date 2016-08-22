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

  def source_file(path)
    raw = `env -i bash -c "source #{path} && env" 2>/dev/null`
    raw.split("\n").each do |line|
      key, value = line.strip.split('=', 2)
      next if %w(PWD SHLVL _).include?(key)
      value.strip!
      yield [key, value] if block_given?
      state[key] = value
    end
  end

  private

  attr_reader :state
end
