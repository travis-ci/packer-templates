# frozen_string_literal: true

require 'json'

class PackerManifest
  def initialize(filename: nil)
    @filename = filename || default_manifest_filename
  end

  attr_reader :filename
  private :filename

  def find(pattern)
    found = []
    manifest.fetch('builds').each do |build|
      (build.fetch('files') || []).each do |artifact|
        found << artifact['name'] if artifact['name'] =~ pattern
      end
    end
    found
  end

  private def default_manifest_filename
    File.expand_path('../../tmp/packer-manifest.json', __FILE__)
  end

  private def manifest
    @manifest ||= JSON.parse(File.read(filename))
  end
end
