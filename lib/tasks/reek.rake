namespace :metrics do
  task :reek do
    MetricFu.generate_reek_report
  end
end