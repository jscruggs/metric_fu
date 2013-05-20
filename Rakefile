#!/usr/bin/env rake
require 'bundler/setup'


Dir['./gem_tasks/*.rake'].each do |task|
  import(task)
end

# $LOAD_PATH << '.'
begin
  require 'spec/rake/spectask'
  desc "Run all specs in spec directory"
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
rescue LoadError
  require 'rspec/core/rake_task'
  desc "Run all specs in spec directory"
  RSpec::Core::RakeTask.new(:spec)
end

require File.expand_path File.join(File.dirname(__FILE__),'lib/metric_fu')

task :default => :spec
