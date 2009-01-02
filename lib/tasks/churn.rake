require File.join(File.dirname(__FILE__), '../metric_fu/churn')

namespace :metrics do

  desc "Which files change the most"
  task :churn do
    MetricFu.generate_churn_report
  end
end
