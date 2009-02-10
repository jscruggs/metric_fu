namespace :metrics do

  STATS_DIR = File.join(MetricFu.scratch_directory, 'stats')
  STATS_FILE = File.join(STATS_DIR, 'index.html')

  desc "A stats report"
  task :stats do
    mkdir_p(STATS_DIR) unless File.directory?(STATS_DIR)
    `rake stats > #{STATS_FILE}`
    MetricFu.generate_stats_report
  end
end
