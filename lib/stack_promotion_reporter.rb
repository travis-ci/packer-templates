require 'json'
require 'uri'

require_relative 'env'

class StackPromotionReporter
  def self.report!
    exit 0 if new.report
    exit 1
  end

  def report
    stacks.each do |stack|
      groups.each do |cur, nxt|
        fetch_diff(cur, nxt, stack)
      end
    end
    0
  end

  private

  def env
    @env ||= Env.new
  end

  def top
    @top ||= `git rev-parse --show-toplevel`.strip
  end

  def stacks
    @stacks ||= (
      dists.map { |d| `#{top}/bin/list-stacks #{d}`.strip.split }.flatten
    )
  end

  def dists
    @dists ||= env.fetch('DISTS', 'trusty,precise').split(',').map(&:strip)
  end

  def groups
    @groups ||= Hash[
      env.fetch('GROUPS', 'stable:edge')
         .split(',')
         .map(&:strip)
         .map { |kv| kv.split(':', 2) }
    ]
  end

  def fetch_diff(cur, nxt, stack)
    cur_image = latest_image(stack, cur)
    nxt_image = latest_image(stack, nxt)
    $stdout.puts "---> stack=#{stack} cur=#{cur_image} nxt=#{nxt_image}"
    # TODO: fetch image metadata tarball(s) and ... stuff
  end

  def latest_image(stack, group)
    q = URI.encode_www_form(
      name: "^travis-ci-#{stack}.*",
      infra: 'gce',
      tags: "group_#{group}:true",
      'fields[images]' => 'name'
    )

    JSON.parse(
      `#{curl_exe} -f -s '#{env['JOB_BOARD_IMAGES_URL']}?#{q}'`
    ).fetch('data').map { |e| e['name'] }.sort.first
  end

  def curl_exe
    @curl_exe ||= env.fetch('CURL_EXE', 'curl')
  end
end
