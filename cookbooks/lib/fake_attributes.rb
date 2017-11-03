# frozen_string_literal: true

require_relative 'forever_hash'

class FakeAttributes < ForeverHash
  def initialize(attributes_filename)
    @attributes_filename = attributes_filename
  end

  def eval!
    instance_eval(File.read(attributes_filename))
    self
  end

  def default
    self
  end

  def node
    self
  end

  def override
    self
  end

  def languages
    fetch('travis_packer_templates')
      .fetch('job_board')
      .fetch('languages')
      .reject { |lang| lang =~ /^__[a-z]+__/ }
  end

  def features
    fetch('travis_packer_templates')
      .fetch('job_board')
      .fetch('features')
  end

  private

  attr_reader :attributes_filename
end
