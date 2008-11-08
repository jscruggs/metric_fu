namespace :metrics do
  task :prepare do
    RAILS_ENV = 'test'
  end
  
  desc "Useful for continuous integration"
  task :all_with_migrate => [:prepare, "db:migrate", :all]
  
  if MetricFu::RAILS
    desc "Generate coverage, cyclomatic complexity, flog, stats, and churn reports"
    task :all => [:coverage, :saikuro, :flog, :churn, :stats]
  else
    desc "Generate coverage, cyclomatic complexity, flog, and churn reports"
    task :all => [:coverage, :saikuro, :flog, :churn]
  end
end