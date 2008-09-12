namespace :metricks do
  task :prepare do
    RAILS_ENV = 'test'
  end
  
  desc "Useful for continuous integration"
  task :all_with_migrate => [:prepare, "db:migrate", :all]
  
  desc "Generate coverage, cyclomatic complexity (saikuro), flog, stats, and churn reports"
  task :all => [:coverage, :saikuro, :flog, :churn, :stats]
end