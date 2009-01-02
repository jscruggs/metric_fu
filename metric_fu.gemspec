Gem::Specification.new do |s|
  s.name = "metric_fu" 
  s.version = "0.8.4.7" 
  s.summary = "A fistful of code metrics"
  s.email = "jake.scruggs@gmail.com"
  s.homepage = "http://metric-fu.rubyforge.org/"
  s.description = "Code metrics from Flog, Flay, RCov, Saikuro, Churn, and Rails' stats task"
  s.authors = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus"]

  s.files = [
    "README",
    "HISTORY",
    "TODO",
    "MIT-LICENSE",
    "Rakefile"]

  # Dir['lib/**/*.rb'] + Dir['lib/tasks/*'] + Dir['lib/templates/*']
  s.files += ["lib/metric_fu/base.rb",
    "lib/metric_fu/churn.rb",
    "lib/metric_fu/flay.rb",
    "lib/metric_fu/flog.rb",
    "lib/metric_fu/md5_tracker.rb",
    "lib/metric_fu/saikuro/saikuro.rb",
    "lib/metric_fu.rb",
    "lib/tasks/metric_fu.rb",
    "lib/tasks/churn.rake",
    "lib/tasks/coverage.rake",
    "lib/tasks/flay.rake",
    "lib/tasks/flog.rake",
    "lib/tasks/metric_fu.rake",
    "lib/tasks/metric_fu.rb",
    "lib/tasks/railroad.rake",
    "lib/tasks/reek.rake",
    "lib/tasks/roodi.rake",    
    "lib/tasks/saikuro.rake",
    "lib/tasks/stats.rake",
    "lib/templates/churn.css",
    "lib/templates/churn.html.erb",
    "lib/templates/flay.css",
    "lib/templates/flay.html.erb",
    "lib/templates/flog.css",
    "lib/templates/flog.html.erb",
    "lib/templates/flog_page.html.erb"]

  # Dir['spec/**/*.rb']
  s.test_files = ["spec/base_spec.rb",
   "spec/churn_spec.rb",
   "spec/flay_spec.rb",
   "spec/flog_spec.rb",
   "spec/md5_tracker_spec.rb",
   "spec/spec_helper.rb"]


  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["HISTORY", "Manifest.txt", "README"]
  s.add_dependency("flay", ["> 0.0.0"])  
  s.add_dependency("flog", [">= 1.2.0"])
  s.add_dependency("rcov", ["> 0.8.1"])
  s.add_dependency("railroad", [">= 0.5.0"])  
  s.add_dependency("reek", ["> 0.0.0"])
  s.add_dependency("roodi", ["> 0.0.0"])
end