require 'test/unit'
require 'fileutils'

ENV['CC_BUILD_ARTIFACTS'] = File.join(File.dirname(__FILE__), 'tmp')

require File.join(File.dirname(__FILE__), '..', 'lib', 'metricks')
