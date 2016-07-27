class ForeverHash < Hash
  def [](key)
    self[key] = ForeverHash.new unless key?(key)
    fetch(key)
  end
end
