require 'metric_fu'
require 'rails'

module MetricFu
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/metric_fu.rake"
    end
  end
end