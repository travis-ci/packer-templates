# frozen_string_literal: true

require_relative 'stack_promotion_hydrator'
require_relative 'stack_promotion_image'

class StackPromotion
  MissingMetadata = Class.new(StandardError)

  def initialize(stack: '', cur: '', nxt: '', deprecated: '')
    @stack = stack
    @cur = StackPromotionImage.new(stack: stack, group: cur)
    @nxt = StackPromotionImage.new(stack: stack, group: nxt)
    @deprecated = deprecated
  end

  attr_reader :stack, :cur, :nxt, :deprecated

  def hydrate!(output_dir: '.')
    raise MissingMetadata if cur.metadata.nil? || nxt.metadata.nil?

    cur.metadata.load!
    nxt.metadata.load!

    StackPromotionHydrator.new(
      stack_promotion: self,
      output_dir: output_dir
    ).hydrate!
  end

  def cur_job_board_hash
    cur.metadata.job_board_register_hash.tap do |h|
      h['name'] = cur.name
      h['successor_name'] = nxt.name
      h['tags'].merge!(
        'group' => deprecated,
        "group_#{deprecated}" => true
      )
      h['tags_string'] = %W[
        group:#{deprecated}
        group_#{deprecated}:true
        #{h['tags_string']}
      ].join(',')
    end
  end

  def nxt_job_board_hash
    nxt.metadata.job_board_register_hash.tap do |h|
      h['name'] = nxt.name
      h['tags'].merge!(
        'group' => cur.group,
        "group_#{cur.group}" => true
      )
      h['tags_string'] = %W[
        group:#{cur.group}
        group_#{cur.group}:true
        #{h['tags_string']}
      ].join(',')
    end
  end
end
