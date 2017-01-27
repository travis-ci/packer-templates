require 'json'
require 'pathname'
require 'time'
require 'tmpdir'
require 'uri'

require_relative 'env'
require_relative 'stack_promotion'

class StackPromotionReporter
  def initialize(argv: ARGV)
    @output_dir = Pathname.new(argv.first).expand_path unless argv.first.nil?
  end

  def self.report!(argv: ARGV)
    exit 0 if new(argv: argv).report
    exit 1
  end

  def report
    stacks.each do |stack|
      groups.each do |cur, nxt|
        report_promotion(cur, nxt, stack)
      end
    end
    0
  end

  private def env
    @env ||= Env.new
  end

  private def top
    @top ||= `git rev-parse --show-toplevel`.strip
  end

  private def stacks
    @stacks ||=
      dists.map { |d| `#{top}/bin/list-stacks #{d}`.strip.split }.flatten
  end

  private def dists
    @dists ||= env.fetch('DISTS', 'trusty,precise').split(',').map(&:strip)
  end

  private def groups
    @groups ||= Hash[
      env.fetch('GROUPS', 'stable:edge')
         .split(',')
         .map(&:strip)
         .map { |kv| kv.split(':', 2) }
    ]
  end

  private def output_dir
    @output_dir ||= Pathname.new(
      env.fetch('OUTPUT_DIR', nil) || File.join(
        Dir.tmpdir,
        "stack-promotion-report-#{Time.now.utc.iso8601}"
      )
    ).expand_path
  end

  private def report_promotion(cur, nxt, stack)
    StackPromotion.new(
      stack: stack, cur: cur, nxt: nxt
    ).hydrate!(output_dir: output_dir.join(stack))
  end
end
