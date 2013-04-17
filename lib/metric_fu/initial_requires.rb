require 'rake'

require 'yaml'
# Psych is not defined in Ruby < 1.9
if defined?(Psych)
  # Syck is not available in Ruby > 1.9
  YAML::ENGINE.yamler = 'syck' if defined?(Syck)
end

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
