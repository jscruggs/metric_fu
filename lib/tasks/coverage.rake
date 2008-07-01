require 'fileutils'

begin
  require 'rcov'
  require 'rcov/rcovtask'

  namespace :metricks do

    COVERAGE_DIR = File.join(Metricks::BASE_DIRECTORY, 'coverage')
    COVERAGE_DATA_FILE = File.join(Metricks::BASE_DIRECTORY, 'coverage.data')

    namespace :coverage do
      rcov_output = COVERAGE_DIR
      
      desc "Delete aggregate coverage data."
      task(:clean) { rm_f("rcov_tmp", :verbose => false) }

      desc "RCov task to generate report"
      Rcov::RcovTask.new(:do => :clean) do |t|
        FileUtils.mkdir_p(Metricks::BASE_DIRECTORY) unless File.directory?(Metricks::BASE_DIRECTORY)
        t.test_files = FileList['test/**/*_test.rb']
        t.rcov_opts = ["--sort coverage", "--aggregate '#{COVERAGE_DATA_FILE}'", "--html", "--rails"]
        t.output_dir = COVERAGE_DIR
      end
    end
    
    desc "Generate and open coverage report"
    task :coverage => ['coverage:do'] do
      system("open #{COVERAGE_DIR}/index.html") if PLATFORM['darwin']
    end
  end
rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - rcov tasks not available'
  else
    puts 'sudo gem install rcov # if you want the rcov tasks'
  end
end