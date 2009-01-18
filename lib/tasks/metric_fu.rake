# only load configured metrics
MetricFu.metrics.each { |task| import "#{File.dirname(__FILE__)}/#{task}.rake" }

namespace :metrics do
  if MetricFu::RAILS

    desc "Generate coverage, cyclomatic complexity, flog, flay, railroad, reek, roodi, stats and churn reports"
    task :all => MetricFu.metrics

    task :set_testing_env do
      RAILS_ENV = 'test'
    end

    desc "Generate metrics after migrating (for continuous integration)"
    task :all_with_migrate => [:set_testing_env, "db:migrate", :all]

  else

    desc "Generate coverage, cyclomatic complexity, flog, flay, railroad and churn reports"
    task :all => MetricFu.metrics

  end

end