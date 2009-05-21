Gem::Specification.new do |s|
  s.name = "metric_fu" 
  s.version = "1.0.3" 
  s.summary = "A fistful of code metrics"
  s.email = "jake.scruggs@gmail.com"
  s.homepage = "http://metric-fu.rubyforge.org/"
  s.description = "Code metrics from Flog, Flay, RCov, Saikuro, Churn, Reek, Roodi and Rails' stats task"
  s.authors = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes", "Nick Quaranto"]

  s.files = [
    "README",
    "HISTORY",
    "TODO",
    "MIT-LICENSE",
    "Rakefile"] + Dir['lib/**/*.*'] + Dir['tasks/*.*'] + Dir['vendor/**/*.*']
  s.test_files = ["spec/base/base_template_spec.rb", "spec/base/configuration_spec.rb", "spec/base/generator_spec.rb", "spec/base/md5_tracker_spec.rb", "spec/base/report_spec.rb", "spec/generators/churn_spec.rb", "spec/generators/flay_spec.rb", "spec/generators/flog_spec.rb", "spec/generators/reek_spec.rb", "spec/generators/saikuro_spec.rb", "spec/generators/stats_spec.rb", "spec/spec_helper.rb"]


  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["HISTORY", "Manifest.txt", "README"]
  s.add_dependency("flay", [">= 1.2.1"])
  s.add_dependency("flog", [">= 2.1.0"])
  s.add_dependency("rcov", ["> 0.8.3"])
  s.add_dependency("reek", [">= 1.0.0"])
  s.add_dependency("roodi", [">= 1.3.5"])
  s.add_dependency("chronic", [">= 0.2.3"])
end
