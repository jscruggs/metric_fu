if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-rcov-text'
  SimpleCov.formatter = SimpleCov::Formatter::RcovTextFormatter
  SimpleCov.start
end

require 'rspec/autorun'
require 'date'
require 'construct'
require 'json'

# add lib to the load path just like rubygems does
$:.push File.expand_path("../../lib", __FILE__)
require 'metric_fu'
include MetricFu
def mf_log(msg); mf_debug(msg); end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[MetricFu.root_dir + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]
  config.fail_fast = ENV.include?('FAIL_FAST')
  config.order = 'random'

  # :suite after/before all specs
  # :each every describe block
  # :all every it block

  config.after(:suite) do
    cleanup_fs
  end

  config.after(:each) do
    MetricFu.reset
  end
end
