namespace :metrics do
  desc "Generate code duplication report with flay"
  task :flay do
    MetricFu.generate_flay_report
  end
end