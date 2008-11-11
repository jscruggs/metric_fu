require File.join(File.dirname(__FILE__), '../metric_fu/churn')

namespace :metrics do

  desc "Which files change the most"
  task :churn do
    churn_dir = File.join(MetricFu::BASE_DIRECTORY, 'churn')
    MetricFu::Churn.generate_report(churn_dir, defined?(MetricFu::CHURN_OPTIONS) ? MetricFu::CHURN_OPTIONS : {} )
    system("open #{churn_dir}/index.html") if PLATFORM['darwin']
  end
end
