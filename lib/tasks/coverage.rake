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

      desc "RCov task to generate report"
      Spec::Rake::SpecTask.new(:do => :clean) do |t|
        FileUtils.mkdir_p(MetricFu::BASE_DIRECTORY) unless File.directory?(MetricFu::BASE_DIRECTORY)
        t.ruby_opts = ['-rtest/unit']
        t.spec_files = FileList['test/**/*_test.rb', 'spec/**/*spec.rb']
        t.spec_opts = ["--format", "html:#{SPEC_HTML_FILE}", "--diff"]
        t.rcov = true
        t.rcov_opts = ["--sort coverage", "--html", "--rails", "--exclude /gems/,/Library/"]
        t.rcov_dir = COVERAGE_DIR
      end

      desc "Fails if coverage is lower than provided THRESHOLD (default = 100.0)"
      task :verify do
        ENV['THRESHOLD'] ||= "100.0"
        threshold = ENV['THRESHOLD'].to_f
        coverage = nil
        File.open(COVERAGE_DIR+'/index.html').each do |line|
          if line =~ /<tt class='coverage_code'>(\d+\.\d+)%<\/tt>/
            coverage = $1.to_f
            break
          end
        end
        raise "Coverage is #{coverage}%; should be at least #{threshold}%" if coverage < threshold
        puts "Coverage is #{coverage}%"
      end
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