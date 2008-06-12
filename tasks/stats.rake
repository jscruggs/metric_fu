require 'fileutils'

namespace :metricks do
  
  STATS_DIR = File.join(Metricks::BASE_DIRECTORY, 'stats')
  
  desc "A stats report"
  task :stats do
    mkdir_p(STATS_DIR) unless File.directory?(STATS_DIR)
    sh "rake stats > #{File.join(STATS_DIR, 'stats.log')}"
    system("open #{File.join(STATS_DIR, 'stats.log')}") if PLATFORM['darwin']
  end
end