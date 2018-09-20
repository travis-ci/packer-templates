# frozen_string_literal: true

require 'pathname'
require 'yaml'
require 'job_board_tags'

class SystemInfoCommandsGenerator
  def initialize(argv: ARGV, top: '.')
    @argv = argv
    @top = Pathname.new(File.expand_path(top))
  end

  def generate!
    if !(%w[-h --help help] & argv).empty? || argv.length != 1
      warn "Usage: #{File.basename($PROGRAM_NAME)} <stack>"
      return 1
    end

    system_info_commands = {
      'NOTE' => 'this is a generated file', 'stack' => stack,
      'commands' => { 'linux' => [], 'osx' => [], 'common' => [] }
    }

    %w[features languages].each { |t| merge_tagset!(t, system_info_commands) }

    $stdout.puts YAML.dump(system_info_commands)
    0
  end

  private

  attr_reader :argv, :top

  def stack
    @stack ||= argv.fetch(0)
  end

  def merge_tagset!(tagset, system_info_commands)
    JobBoardTags.new.load_tagset(
      tagset,
      top.join("cookbooks/travis_ci_#{stack}/attributes/default.rb")
    ).each do |tag|
      merge_file = top.join("packer-assets/system-info.d/#{tag}.yml")
      if merge_file.exist?
        merge_tagset_commands!(
          YAML.safe_load(merge_file.read)['commands'],
          system_info_commands
        )
      else
        warn "INFO: skipping missing tag file #{merge_file}"
      end
    end
  end

  def merge_tagset_commands!(commands, system_info_commands)
    return if commands.nil? || commands.empty?

    %w[linux osx common].each do |section|
      value = commands[section]
      next if value.nil? || value.empty?

      system_info_commands['commands'][section] += (
        value - system_info_commands['commands'][section]
      )
    end
  end
end
