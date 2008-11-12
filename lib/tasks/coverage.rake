require 'fileutils'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

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

    RCov::VerifyTask.new(:verify => :do) do |t|
      t.threshold = ( ENV['THRESHOLD'] ? ENV['THRESHOLD'].to_f : 100.0 )
      t.index_html = File.join(COVERAGE_DIR, 'index.html')
    end
  end

  end

  desc "Generate and open coverage report"
  task :coverage => ['coverage:do'] do
    system("open #{COVERAGE_DIR}/index.html") if PLATFORM['darwin']
  end
end
