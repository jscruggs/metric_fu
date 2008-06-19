require 'fileutils'

begin
  require 'rcov'
  require 'rcov/rcovtask'

  namespace :metricks do

    COVERAGE_DIR = File.join(Metricks::BASE_DIRECTORY, 'coverage')
    COVERAGE_DATA_FILE = File.join(COVERAGE_DIR, 'coverage.data')

    namespace :coverage do
      rcov_output = COVERAGE_DIR
      
      desc "Delete aggregate coverage data."
      task(:clean) { rm_f("rcov_tmp", :verbose => false) }

      desc "RCov task to generate report"
      Rcov::RcovTask.new(:unit => :clean) do |t|
        FileUtils.mkdir_p(COVERAGE_DIR) unless File.directory?(COVERAGE_DIR)
        t.test_files = FileList['test/**/*_test.rb']
        t.rcov_opts = ["--sort coverage", "--aggregate '#{COVERAGE_DATA_FILE}'", "--html", "--rails"]
        t.output_dir = COVERAGE_DIR + '/unit'
      end
    end
    
    desc "Generate and open coverage report"
    task :coverage => ['coverage:unit'] do
      system("open #{COVERAGE_DIR}/unit/index.html") if PLATFORM['darwin']
    end
  end
rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - rcov tasks not available'
  else
    puts 'sudo gem install rcov # if you want the rcov tasks'
  end
end