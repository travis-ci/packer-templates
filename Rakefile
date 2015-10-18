require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

task spec: 'spec:all'
task default: ['spec/bin/rabbitmqadmin', :spec]

file 'spec/bin/rabbitmqadmin' do |t|
  require 'faraday'

  rabbitmqadmin_url = (
    ENV['RABBITMQADMIN_URL'] ||
    'http://hg.rabbitmq.com/rabbitmq-management/raw-file/tip/bin/rabbitmqadmin'
  )

  File.open(t.name, 'w') do |f|
    f.puts Faraday.get(rabbitmqadmin_url).body
  end

  File.chmod(0755, t.name)
end

namespace :spec do
  targets = []

  Dir.glob('./cookbooks/**/spec') do |spec_dir|
    next unless File.directory?(spec_dir)
    targets << File.basename(File.dirname(spec_dir))
  end

  task all: %w(spec/bin/rabbitmqadmin) + targets
  task default: :all

  targets.each do |target|
    desc "Run serverspec tests for #{target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      t.rspec_opts = (ENV['RSPEC_OPTS'] || '')
      t.pattern = "./cookbooks/#{target}/spec/*_spec.rb"
    end
  end
end
