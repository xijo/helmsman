require "bundler/gem_tasks"

task :console do
  require 'irb'
  require 'irb/completion'
  require 'helmsman'
  ARGV.clear
  IRB.start
end

begin
    require 'rspec/core/rake_task'
      RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :default => :spec
