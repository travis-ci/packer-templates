# frozen_string_literal: true

require 'json'
require 'uri'

require_relative 'env'
require_relative 'image_metadata_fetcher'

class StackPromotionImage
  def initialize(stack: '', group: '')
    @stack = stack
    @group = group
  end

  attr_reader :stack, :group

  def name
    @name ||= begin
      q = URI.encode_www_form(
        name: "^travis-ci-#{stack}.*",
        infra: 'gce',
        tags: "group_#{group}:true",
        'fields[images]' => 'name'
      )

      JSON.parse(
        `#{curl_exe} -f -s '#{env['JOB_BOARD_IMAGES_URL']}?#{q}'`
      ).fetch('data').map { |e| e['name'] }.max
    end
  end

  def metadata
    @metadata ||= ImageMetadataFetcher.new(
      image_name: name
    ).fetch
  end

  private def env
    @env ||= Env.new
  end

  private def curl_exe
    @curl_exe ||= env.fetch('CURL_EXE', 'curl')
  end
end
