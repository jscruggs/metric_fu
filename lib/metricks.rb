module Metricks
  BASE_DIRECTORY = ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metricks'
end

require File.join(File.dirname(__FILE__), 'metricks', 'md5_tracker')
require File.join(File.dirname(__FILE__), 'metricks', 'flog_reporter')
