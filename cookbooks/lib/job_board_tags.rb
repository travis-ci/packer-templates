# frozen_string_literal: true

require_relative 'fake_attributes'

class JobBoardTags
  def initialize
    @attributes_cache = {}
  end

  def load_tagset(tagset, attributes_filename)
    load_attributes(attributes_filename).send(tagset)
  end

  @attributes_cache = {}

  def load_attributes(attributes_filename)
    @attributes_cache[attributes_filename] ||=
      FakeAttributes.new(attributes_filename).eval!
  end
end
