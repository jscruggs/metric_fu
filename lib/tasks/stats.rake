namespace :metrics do

  STATS_DIR = File.join(MetricFu::BASE_DIRECTORY, 'stats')
  STATS_FILE = File.join(STATS_DIR, 'index.html')

  desc "A stats report"
  task :stats do
    mkdir_p(STATS_DIR) unless File.directory?(STATS_DIR)
    `echo '<pre>' > #{STATS_FILE}`
    `rake stats >> #{STATS_FILE}`
    `echo '</pre>' >> #{STATS_FILE}`
    system("open #{STATS_FILE}") if MetricFu.open_in_browser?
  end
end
