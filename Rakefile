begin
  require 'rubocop/rake_task'
rescue LoadError => e
  warn e
end

RuboCop::RakeTask.new if defined?(RuboCop)

task default: [:rubocop]
