Gem::Specification.new do |s|
  s.name = "metric_fu"
  s.version = "0.8.1"
  s.summary = "A fistful of code metrics"
  s.email = "jake.scruggs@gmail.com"
  s.homepage = "http://metric-fu.rubyforge.org/"
  s.description = "Code metrics from Flog, RCov, Saikuro, Churn, and Rails' stats task"
  s.authors = ["Jake Scruggs", "Sean Soper", "Andre Arko"]
  
  # Dir['lib/**/*.rb'] + Dir['lib/tasks/*']
  s.files = [
    "README",
    "HISTORY",
    "TODO",
    "MIT-LICENSE",
    "Rakefile",
    "lib/metric_fu/churn.rb",
    "lib/metric_fu/flay.rb",
    "lib/metric_fu/flog_reporter/base.rb",
    "lib/metric_fu/flog_reporter/generator.rb",
    "lib/metric_fu/flog_reporter/operator.rb",
    "lib/metric_fu/flog_reporter/page.rb",
    "lib/metric_fu/flog_reporter/scanned_method.rb",
    "lib/metric_fu/flog_reporter.rb",
    "lib/metric_fu/md5_tracker.rb",
    "lib/metric_fu/saikuro/saikuro.rb",
    "lib/metric_fu.rb",
    "lib/tasks/metric_fu.rb",
    "lib/tasks/churn.rake",
    "lib/tasks/coverage.rake",
    "lib/tasks/flog.rake",
    "lib/tasks/metric_fu.rake",
    "lib/tasks/metric_fu.rb",
    "lib/tasks/saikuro.rake",
    "lib/tasks/stats.rake"
  ]
  
  # Dir['spec/**/*.rb']
  s.test_files = [
    "spec/churn_spec.rb",
    "spec/flog_reporter/base_spec.rb",
    "spec/md5_tracker_spec.rb"
  ]
  
  
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["HISTORY", "README"]
  
  s.add_dependency("flog", [">= 1.2.0"])
  s.add_dependency("rcov", [">= 0.8.1"])
  s.add_dependency("flay", ["> 0.0.0"])
end