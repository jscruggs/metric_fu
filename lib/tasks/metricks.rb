require 'fileutils'
require 'rubygems'
require 'rake'

# Load rake files
Dir["#{File.dirname(__FILE__)}/*.rake"].each { |ext| load ext }