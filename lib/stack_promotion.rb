require 'json'
require 'logger'

require_relative 'env'
require_relative 'image_metadata_fetcher'
require_relative 'stack_promotion_hydrator'

class StackPromotion
  def initialize(stack: '', cur: '', nxt: '', logger: nil)
    @stack = stack
    @cur = cur
    @nxt = nxt
    @logger = logger
    @cur_image = nil
    @nxt_image = nil
  end

  attr_reader :stack, :cur, :nxt, :cur_image, :nxt_image

  def hydrate!(output_dir: '.')
    cur_metadata, nxt_metadata = fetch_metadata
    return if cur_metadata.nil? || nxt_metadata.nil?

    StackPromotionHydrator.new(
      stack_promotion: self,
      output_dir: output_dir,
      cur_metadata: cur_metadata,
      nxt_metadata: nxt_metadata
    ).hydrate!
  end

  private def fetch_metadata
    @cur_image = latest_image(stack, cur)
    @nxt_image = latest_image(stack, nxt)
    logger.info "stack=#{stack} cur=#{cur_image} nxt=#{nxt_image}"

    cur_metadata = fetch_image_metadata_tarball(cur_image)
    nxt_metadata = fetch_image_metadata_tarball(nxt_image)
    if cur_metadata.nil? || nxt_metadata.nil?
      logger.error "missing metadata? cur=#{cur_metadata} nxt=#{nxt_metadata}"
      return [nil, nil]
    end

    cur_metadata.load!
    nxt_metadata.load!

    logger.info "cur-metadata=#{cur_metadata}"
    logger.info "nxt-metadata=#{nxt_metadata}"

    [cur_metadata, nxt_metadata]
  end

  private def env
    @env ||= Env.new
  end

  private def fetch_image_metadata_tarball(image_name)
    ImageMetadataFetcher.new(image_name: image_name).fetch
  end

  private def latest_image(stack, group)
    q = URI.encode_www_form(
      name: "^travis-ci-#{stack}.*",
      infra: 'gce',
      tags: "group_#{group}:true",
      'fields[images]' => 'name'
    )

    JSON.parse(
      `#{curl_exe} -f -s '#{env['JOB_BOARD_IMAGES_URL']}?#{q}'`
    ).fetch('data').map { |e| e['name'] }.sort.last
  end

  private def curl_exe
    @curl_exe ||= env.fetch('CURL_EXE', 'curl')
  end

  private def logger
    @logger ||= Logger.new($stdout)
  end
end
