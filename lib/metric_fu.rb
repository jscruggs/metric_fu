require 'rake'
require 'yaml'
begin
  require 'psych'
  YAML::ENGINE.yamler = 'syck'
rescue LoadError
  #nothing to report
end
# def with_syck(&block)
#   current_engine = YAML::ENGINE.yamler
#   YAML::ENGINE.yamler = 'syck'
#   block.call
#   YAML::ENGINE.yamler = current_engine
# end
begin
  require 'active_support'
  require 'active_support/core_ext/object/to_json'
  require 'active_support/core_ext/object/blank'
  require 'active_support/inflector'
rescue LoadError
  require 'activesupport' unless defined?(ActiveSupport)
end

module MfDebugger
  class Logger
    class << self
      attr_accessor :debug_on
      @debug_on = false
    end
  end

  def self.mf_debug(msg,&block)
    if MfDebugger::Logger.debug_on
      if block_given?
        block.call
      end
      STDOUT.puts msg
    end
  end
  def mf_debug(msg,&block)
    if block_given?
      MfDebugger.mf_debug(msg,&block)
    else
      MfDebugger.mf_debug(msg)
    end
  end
end
include MfDebugger
MfDebugger::Logger.debug_on = !!(ENV['MF_DEBUG'] =~ /true/i)

# Load a few things to make our lives easier elsewhere.
module MetricFu
  LIB_ROOT = File.dirname(__FILE__)
end
base_dir         = File.join(MetricFu::LIB_ROOT, 'base')
generator_dir    = File.join(MetricFu::LIB_ROOT, 'generators')
template_dir     = File.join(MetricFu::LIB_ROOT, 'templates')
graph_dir        = File.join(MetricFu::LIB_ROOT, 'graphs')

# We need to require these two (sic?) things first because our other classes
# depend on them.
require File.expand_path File.join(base_dir, 'report')
require File.expand_path File.join(base_dir, 'generator')
require File.expand_path File.join(base_dir, 'graph')
require File.expand_path File.join(base_dir, 'scoring_strategies')

# prevent the task from being run multiple times.
unless Rake::Task.task_defined? "metrics:all"
  # Load the rakefile so users of the gem get the default metric_fu task
  load File.expand_path File.join(MetricFu::LIB_ROOT, '..', 'tasks', 'metric_fu.rake')
end

# Now load everything else that's in the directory
Dir[File.expand_path File.join(base_dir, '*.rb')].each{|l| require l }
Dir[File.expand_path File.join(generator_dir, '*.rb')].each {|l| require l }
Dir[File.expand_path File.join(template_dir, 'standard/*.rb')].each {|l| require l}
Dir[File.expand_path File.join(template_dir, 'awesome/*.rb')].each {|l| require l}
require graph_dir + "/grapher"
Dir[File.expand_path File.join(graph_dir, '*.rb')].each {|l| require l}
Dir[File.expand_path File.join(graph_dir, 'engines', '*.rb')].each {|l| require l}
