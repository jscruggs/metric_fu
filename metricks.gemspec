Gem::Specification.new do |s|
  s.name = "metricks"
  s.version = "0.2"
  s.date = "2008-06-1"
  s.summary = "Generates project metrics using Flog, RCov, Saikuro and more"
  s.email = "sean.soper@gmail.com"
  s.homepage = "http://github.com/ssoper/metricks"
  s.description = "Metricks is a fork of the metric_fu project and adds support for additional code analysis tools"
  s.has_rdoc = true
  s.authors = ["Sean Soper"]
  s.files = ["History.txt", "Manifest.txt", "metricks.gemspec", "MIT-LICENSE", "README", "TODO.txt", "lib/metricks.rb", "lib/metricks/flog_reporter.rb", "lib/metricks/md5_tracker.rb", "lib/metricks/flog_reporter/base.rb", "lib/metricks/flog_reporter/flog_reporter.css", "lib/metricks/flog_reporter/generator.rb", "lib/metricks/flog_reporter/operator.rb", "lib/metricks/flog_reporter/page.rb", "lib/metricks/flog_reporter/scanned_method.rb", "lib/metricks/saikuro/saikuro.rb", "lib/metricks/saikuro/SAIKURO_README", "tasks/churn.rake", "tasks/coverage.rake", "tasks/flog.rake", "tasks/metricks.rake", "tasks/saikuro.rake", "tasks/stats.rake", "test/test_helper.rb", "test/test_md5_tracker.rb"]
  s.test_files = ["test/test_md5_tracker.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  # s.add_dependency("mime-types", ["> 0.0.0"])
end