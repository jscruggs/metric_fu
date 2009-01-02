namespace :metrics do
  
  REEK_DIR = File.join(MetricFu::BASE_DIRECTORY, 'reek')
  REEK_FILE = File.join(REEK_DIR, 'index.html')
  
  desc "A code smell report using Reek"
  task :reek do
    mkdir_p(REEK_DIR) unless File.directory?(REEK_DIR)
    `echo '<pre>' > #{REEK_FILE}`
    `reek #{RAILS_ROOT}/test/**/*.rb #{RAILS_ROOT}/app/**/*.rb >> #{REEK_FILE}`
    `echo '</pre>' >> #{REEK_FILE}`
    system("open #{REEK_FILE}") if MetricFu.open_in_browser?
  end
end