namespace :metrics do
  
  desc "A Ruby coding standards report using Roodi"
  task :roodi do
    MetricFu.generate_roodi_report
  end
end