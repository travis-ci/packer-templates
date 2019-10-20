#!/usr/bin/env ruby
# frozen_string_literal: true

libdir = File.expand_path('../../lib', __dir__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'job_board_registrar'

if $PROGRAM_NAME == __FILE__
  matches = Dir.glob(
    File.expand_path(
      "../tmp/#{ENV['IMAGE_METADATA_FILE']}", __dir__
    )
  )
  JobBoardRegistrar.new(matches.max).register!
end
