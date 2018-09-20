# frozen_string_literal: true

require 'json'
require 'logger'
require 'optparse'
require 'pathname'
require 'time'
require 'tmpdir'
require 'uri'

require_relative 'env'
require_relative 'stack_promotion'

class StackPromotionReporter
  def self.report!(argv: ARGV)
    exit 0 if new(argv: argv).report
    exit 1
  end

  def initialize(argv: ARGV)
    @options = {
      output_dir: default_output_dir,
      dists: default_dists,
      groups: default_groups
    }

    parse_args(argv)
  end

  def report
    options[:output_dir].mkpath
    job_board_hashes = []

    stacks.each do |stack|
      groups.each do |nxt, cur, deprecated|
        job_board_hashes += report_promotion(
          cur, nxt, deprecated, stack
        )
      end
    end

    create_stack_promotions_json(job_board_hashes)
    create_stack_promotions_txt(job_board_hashes)

    0
  end

  attr_reader :options

  private def parse_args(argv)
    OptionParser.new do |opts|
      opts.on(
        '-dDIR', '--output-dir=DIR', 'Output directory for report'
      ) do |v|
        @options[:output_dir] = Pathname.new(v.strip).expand_path
      end
      opts.on(
        '-DDISTS', '--dists=DISTS', '","-delimited dist names'
      ) do |v|
        @options[:dists] = v.split(',').map(&:strip)
      end
      opts.on(
        '-GGROUPS', '--groups=GROUPS',
        '","-delimited ":"-separated group name triplets'
      ) do |v|
        @options[:groups] = v.strip.split(',').map(&:strip)
      end
    end.parse!(argv)
  end

  private def create_stack_promotions_json(job_board_hashes)
    stack_promotions_json = options[:output_dir].join('stack-promotions.json')
    logger.info "writing #{stack_promotions_json}"
    stack_promotions_json.write(JSON.pretty_generate(job_board_hashes))
  end

  private def create_stack_promotions_txt(job_board_hashes)
    stack_promotions_txt = options[:output_dir].join('stack-promotions.txt')
    logger.info "writing #{stack_promotions_txt}"
    lines = job_board_hashes.map do |hash|
      URI.encode_www_form(
        'tags' => hash['tags_string'],
        'infra' => hash.fetch('infra', 'gce'),
        'name' => hash['name'],
        'is_default' => hash.fetch('is_default', false).to_s
      )
    end
    stack_promotions_txt.write(lines.join("\n") + "\n")
  end

  private def env
    @env ||= Env.new
  end

  private def top
    @top ||= File.expand_path('..', __dir__)
  end

  private def stacks
    @stacks ||=
      options[:dists].map { |d| `#{top}/bin/list-stacks #{d}`.strip.split }.flatten
  end

  private def default_dists
    env.fetch('DISTS', 'trusty').split(',').map(&:strip)
  end

  private def default_groups
    env.fetch('GROUPS', 'edge:stable:deprecated')
  end

  private def groups
    options[:groups].split(',').map do |group_triplet|
      group_triplet.strip.split(':').map(&:strip)
    end
  end

  private def default_output_dir
    Pathname.new(
      env.fetch('OUTPUT_DIR', nil) || File.join(
        Dir.tmpdir,
        "stack-promotion-report-#{Time.now.utc.iso8601}"
      )
    ).expand_path
  end

  private def report_promotion(cur, nxt, deprecated, stack)
    promotion = StackPromotion.new(
      stack: stack,
      cur: cur,
      nxt: nxt,
      deprecated: deprecated
    )
    promotion.hydrate!(output_dir: options[:output_dir].join(stack))
    [
      promotion.cur_job_board_hash,
      promotion.nxt_job_board_hash
    ]
  rescue StandardError => e
    logger.error "stack=#{stack} #{e}"
    []
  end

  private def logger
    @logger ||= Logger.new($stdout)
  end
end
