require 'rake'

require 'yaml'
require 'redcard'

# Psych is not defined in Ruby < 1.9
if defined?(Psych)
  # Syck is not available in Ruby > 1.9 or JRuby 1.9
  if defined?(Syck) && !RedCard.check(:jruby)
    YAML::ENGINE.yamler = 'syck'
  end
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
