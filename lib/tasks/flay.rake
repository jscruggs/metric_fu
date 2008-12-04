namespace :metrics do
  
  FLAY_DIR = File.join(MetricFu::BASE_DIRECTORY, 'flay')
  FLAY_FILE = File.join(FLAY_DIR, 'index.html')
  
  desc "A code duplication report using flay"
  task :flay do
    mkdir_p(FLAY_DIR) unless File.directory?(FLAY_DIR)
    `echo '<pre>' > #{FLAY_FILE}`
    `flay #{RAILS_ROOT}/test/**/*.rb #{RAILS_ROOT}/app/**/*.rb >> #{FLAY_FILE}`
    `echo '</pre>' >> #{FLAY_FILE}`
    system("open #{FLAY_FILE}") if PLATFORM['darwin']
  end
end