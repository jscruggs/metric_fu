FLAY_DIR = File.join(MetricFu::BASE_DIRECTORY, 'flay')

namespace :metrics do
  desc "Generate code duplication report with flay"
  task :flay do
    MetricFu::FlayReporter.generate_report(FLAY_DIR)
    system("open #{FLAY_DIR}/index.html") if PLATFORM['darwin']
  end
end