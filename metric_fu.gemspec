Gem::Specification.new do |s|
  s.name = "metric_fu" 
  s.version = "1.0.0" 
  s.summary = "A fistful of code metrics"
  s.email = "jake.scruggs@gmail.com"
  s.homepage = "http://metric-fu.rubyforge.org/"
  s.description = "Code metrics from Flog, Flay, RCov, Saikuro, Churn, Reek, Roodi and Rails' stats task"
  s.authors = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes"]

  s.files = [
    "README",
    "HISTORY",
    "TODO",
    "MIT-LICENSE",
    "Rakefile"]

  # Dir['lib/**/*.*'] + Dir['tasks/*.*'] + Dir['vendor/**/*.*']
  s.files += ["lib/base/base_template.rb", "lib/base/configuration.rb", "lib/base/generator.rb", "lib/base/md5_tracker.rb", "lib/base/report.rb", "lib/generators/churn.rb", "lib/generators/flay.rb", "lib/generators/flog.rb", "lib/generators/rcov.rb", "lib/generators/reek.rb", "lib/generators/roodi.rb", "lib/generators/saikuro.rb", "lib/generators/stats.rb", "lib/metric_fu.rb", "lib/templates/standard/churn.html.erb", "lib/templates/standard/default.css", "lib/templates/standard/flay.html.erb", "lib/templates/standard/flog.html.erb", "lib/templates/standard/index.html.erb", "lib/templates/standard/rcov.html.erb", "lib/templates/standard/reek.html.erb", "lib/templates/standard/roodi.html.erb", "lib/templates/standard/saikuro.html.erb", "lib/templates/standard/standard_template.rb", "lib/templates/standard/stats.html.erb", "tasks/metric_fu.rake", "tasks/railroad.rake", "vendor/saikuro/saikuro.rb"]

  # Dir['spec/**/*.rb']
  s.test_files = ["spec/base/base_template_spec.rb", "spec/base/configuration_spec.rb", "spec/base/generator_spec.rb", "spec/base/md5_tracker_spec.rb", "spec/base/report_spec.rb", "spec/generators/churn_spec.rb", "spec/generators/flay_spec.rb", "spec/generators/flog_spec.rb", "spec/generators/reek_spec.rb", "spec/generators/saikuro_spec.rb", "spec/generators/stats_spec.rb", "spec/spec_helper.rb"]


  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["HISTORY", "Manifest.txt", "README"]
  s.add_dependency("flay", [">= 1.2.1"])  
  s.add_dependency("flog", [">= 2.1.0"])
  s.add_dependency("rcov", ["> 0.8.1"])
  s.add_dependency("reek", [">= 1.0.0"])
  s.add_dependency("roodi", [">= 1.3.5"])
  s.add_dependency("chronic", [">= 0.2.3"])
end