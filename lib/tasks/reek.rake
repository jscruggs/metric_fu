namespace :metrics do
  desc "A code smell report using Reek"  
  task :reek do
    MetricFu.generate_reek_report
  end
end