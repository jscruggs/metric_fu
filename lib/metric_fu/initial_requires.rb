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
MetricFu.configure
MetricFu.logging_require { 'mf_debugger' }
include MfDebugger
MfDebugger::Logger.debug_on = !!(ENV['MF_DEBUG'] =~ /true/i)
