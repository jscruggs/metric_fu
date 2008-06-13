require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'test/unit'

task :test do
  runner = Test::Unit::AutoRunner.new(true)
  runner.to_run << 'test'
  runner.run
end

task :default => [:test] do
end