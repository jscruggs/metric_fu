require 'fileutils'

namespace :metricks do
  
  COVERAGE_DIR = File.join(Metricks::BASE_DIRECTORY, 'coverage')
  COVERAGE_DATA_FILE = File.join(COVERAGE_DIR, "coverage.data")
  
  desc "A coverage report using rcov"
  task :coverage do
    FileUtils.rm_rf(COVERAGE_DATA_FILE, :verbose => false) if File.exist?(COVERAGE_DATA_FILE)
    FileUtils.mkdir_p(COVERAGE_DIR) unless File.directory?(COVERAGE_DIR)
    paths = defined?(TEST_PATHS_FOR_RCOV) ? TEST_PATHS_FOR_RCOV : ['test/**/*_test.rb']
    paths.each { |path| execute_rcov(path) }
  end

  def execute_rcov(test_list)
    default_options = {"--rails" => "",
                       "--aggregate" => "#{File.join(COVERAGE_DIR, 'coverage.data')}",
                       "--sort" => "coverage",
                       "--exclude" => '"gems/*,rcov*,spec/*,test/*"',
                       "--output" => %["#{COVERAGE_DIR}"]}
                     
    default_options.merge!(RCOV_OPTIONS) if defined?(RCOV_OPTIONS)
    options = ""
    default_options.each_pair { |key, value| options << "#{key} #{value} " }
  
    sh "rcov #{options} #{test_list}" do |ok, response|
      unless ok
        puts "Rcov failed with exit status: #{response.exitstatus}"
        exit 1
      end
    end
    
    system("open #{COVERAGE_DIR}/index.html") if PLATFORM['darwin']
  end
end