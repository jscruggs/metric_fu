# rake is required for
# Saikuro : sh
# Rcov    : FileList
# loading metric_fu.rake
require 'rake'

require 'yaml'
require 'redcard'

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
