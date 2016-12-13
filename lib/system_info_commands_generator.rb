require 'pathname'
require 'yaml'
require 'job_board_tags'

class SystemInfoCommandsGenerator
  def initialize(argv: ARGV, top: '.')
    @argv = argv
    @top = Pathname.new(File.expand_path(top))
  end

  def generate!
    if !(%w(-h --help help) & argv).empty? || argv.length != 1
      $stderr.puts "Usage: #{File.basename($PROGRAM_NAME)} <stack>"
      return 1
    end

    stack = argv.fetch(0)

    system_info_commands = { 'linux' => [], 'osx' => [], 'common' => [] }
    %w(
      features
      languages
    ).each do |tagset|
      JobBoardTags.new.load_tagset(
        tagset,
        top.join("cookbooks/travis_ci_#{stack}/attributes/default.rb")
      ).each do |tag|
        merge_file = top.join("packer-assets/system-info.d/#{tag}.yml")
        if merge_file.exist?
          YAML.load(merge_file.read).tap do |merge|
            commands = merge['commands']
            next if commands.nil? || commands.empty?

            %w(linux osx common).each do |section|
              value = commands[section]
              next if value.nil? || value.empty?
              system_info_commands[section] += (
                value - system_info_commands[section]
              )
            end
          end
        else
          $stderr.puts "INFO: skipping missing tag file #{merge_file}"
        end
      end
    end

    $stdout.puts YAML.dump(system_info_commands)
    0
  end

  private

  attr_reader :argv, :top
end
