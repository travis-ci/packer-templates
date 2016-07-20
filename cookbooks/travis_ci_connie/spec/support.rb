require 'serverspec'
require_relative '../../lib/support'

set :backend, :exec
set :shell, 'bash'

RSpec.configure do |c|
  c.include Support::Helpers
  c.filter_run_excluding(docker: false) if
    ENV['PACKER_BUILDER_TYPE'] == 'docker'
end
