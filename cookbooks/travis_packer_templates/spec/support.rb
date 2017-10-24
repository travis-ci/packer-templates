# frozen_string_literal: true

require 'serverspec'
require_relative '../../lib/support'

set :backend, :exec
set :shell, 'bash'

RSpec.configure do |c|
  c.include Support::Helpers
end
