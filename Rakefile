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

  Dir.glob('./spec/*') do |dir|
    next unless File.directory?(dir)
    next if %w(bin files).include?(File.basename(dir))
    targets << File.basename(dir)
  end

  task all: %w(spec/bin/rabbitmqadmin) + targets
  task default: :all

  targets.each do |target|
    desc "Run serverspec tests to #{target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = target
      t.rspec_opts = (ENV['RSPEC_OPTS'] || '')
      t.pattern = "spec/#{target}/*_spec.rb"
    end
  end
end
