require 'fileutils'

begin
  require 'rcov'
  require 'rcov/rcovtask'
  require 'spec/rake/spectask'

  namespace :metrics do

    COVERAGE_DIR = File.join(MetricFu::BASE_DIRECTORY, 'coverage')
    COVERAGE_DATA_FILE = File.join(MetricFu::BASE_DIRECTORY, 'coverage.data')
    SPEC_HTML_FILE = File.join(MetricFu::BASE_DIRECTORY, 'specs.html')

    namespace :coverage do
      rcov_output = COVERAGE_DIR
      
      desc "Delete aggregate coverage data."
      task(:clean) { rm_f("rcov_tmp", :verbose => false) }
        
      Spec::Rake::SpecTask.new(:do => :clean) do |t|
        FileUtils.mkdir_p(MetricFu::BASE_DIRECTORY) unless File.directory?(MetricFu::BASE_DIRECTORY)
        t.ruby_opts = ['-rtest/unit']
        t.spec_files = FileList['test/**/*_test.rb', 'spec/**/*spec.rb']
        t.spec_opts = ["--format", "html:#{SPEC_HTML_FILE}", "--diff"]
        t.rcov = true
        t.rcov_opts = ["--sort coverage", "--html", "--rails", "--exclude /gems/,/Library/"]
        t.rcov_dir = COVERAGE_DIR
      end
    end
    
    desc "Generate RCov report"
    task :coverage => ['coverage:do'] do
      system("open #{SPEC_HTML_FILE}") if PLATFORM['darwin']
    end
  end
rescue LoadError
  if RUBY_PLATFORM =~ /java/
    puts 'running in jruby - rcov tasks not available'
  else
    puts 'sudo gem install rcov # if you want the rcov tasks'
  end
end