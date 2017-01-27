require 'json'
require 'optparse'
require 'pathname'
require 'time'
require 'tmpdir'
require 'uri'

require_relative 'env'
require_relative 'stack_promotion'

class StackPromotionReporter
  def initialize(argv: ARGV)
    @options = {
      output_dir: default_output_dir,
      dists: default_dists,
      groups: default_groups
    }

    parse_args(argv)
  end

  def self.report!(argv: ARGV)
    exit 0 if new(argv: argv).report
    exit 1
  end

  def report
    stacks.each do |stack|
      options[:groups].each do |cur, nxt|
        report_promotion(cur, nxt, stack)
      end
    end
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
        '","-delimited ":"-paired group name mapping'
      ) do |v|
        @options[:groups] = string_to_hash(v.strip)
      end
    end.parse!(argv)
  end

  private def env
    @env ||= Env.new
  end

  private def top
    @top ||= `git rev-parse --show-toplevel`.strip
  end

  private def stacks
    @stacks ||=
      options[:dists].map { |d| `#{top}/bin/list-stacks #{d}`.strip.split }.flatten
  end

  private def default_dists
    env.fetch('DISTS', 'trusty,precise').split(',').map(&:strip)
  end

  private def default_groups
    string_to_hash(env.fetch('GROUPS', 'stable:edge'))
  end

  private def string_to_hash(s)
    Hash[
      s.split(',')
       .map(&:strip)
       .map { |kv| kv.split(':', 2) }
    ]
  end

  private def default_output_dir
    Pathname.new(
      env.fetch('OUTPUT_DIR', nil) || File.join(
        Dir.tmpdir,
        "stack-promotion-report-#{Time.now.utc.iso8601}"
      )
    ).expand_path
  end

  private def report_promotion(cur, nxt, stack)
    StackPromotion.new(
      stack: stack, cur: cur, nxt: nxt
    ).hydrate!(output_dir: options[:output_dir].join(stack))
  end
end
