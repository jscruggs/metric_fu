namespace :metrics do
  
  ROODI_DIR = File.join(MetricFu::BASE_DIRECTORY, 'roodi')
  ROODI_FILE = File.join(ROODI_DIR, 'index.html')
  
  desc "A Ruby coding standards report using Roodi"
  task :roodi do
    mkdir_p(ROODI_DIR) unless File.directory?(ROODI_DIR)
    `echo '<pre>' > #{ROODI_FILE}`
    `roodi #{RAILS_ROOT}/lib/**/*.rb #{RAILS_ROOT}/app/**/*.rb >> #{ROODI_FILE}`
    `echo '</pre>' >> #{ROODI_FILE}`
    system("open #{ROODI_FILE}") if MetricFu.open_in_browser?
  end
end