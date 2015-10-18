require 'serverspec'
require_relative 'support/helpers'

set :backend, :exec

RSpec.configure do |c|
  c.include Support::Helpers
end
