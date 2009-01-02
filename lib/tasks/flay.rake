namespace :metrics do
  desc "Generate code duplication report with flay"
  task :flay do
    MetricFu.generate_flay_report
    system("open #{FLAY_DIR}/index.html") if PLATFORM['darwin']
  end
end