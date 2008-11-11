namespace :metrics do
  task :prepare do
    RAILS_ENV = 'test'
  end

  desc "Useful for continuous integration"
  task :all_with_migrate => [:prepare, "db:migrate", :all]

  if MetricFu::RAILS
    desc "Generate coverage, cyclomatic complexity, flog, stats, duplication and churn reports"
    task :all => [:coverage, :saikuro, :flog, :duplication, :churn, :stats]
  else
    desc "Generate coverage, cyclomatic complexity, flog, duplication and churn reports"
    task :all => [:coverage, :saikuro, :flog, :duplication, :churn]
  end
end