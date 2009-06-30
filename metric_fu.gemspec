Gem::Specification.new do |s|
  s.name = "metric_fu" 
  s.version = "1.1.1"
  s.summary = "A fistful of code metrics, with awesome templates and graphs"
  s.email = "jake.scruggs@gmail.com"
  s.homepage = "http://metric-fu.rubyforge.org/"
  s.description = "Code metrics from Flog, Flay, RCov, Saikuro, Churn, Reek, Roodi and Rails' stats task"
  s.authors = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes", "Nick Quaranto", "Édouard Brière"]

  s.files = [
    "README",
    "HISTORY",
    "TODO",
    "MIT-LICENSE",
    "Rakefile"]
    
  # Dir['lib/**/*.*'] + Dir['tasks/*.*'] + Dir['vendor/**/*.*']
  s.files += ["lib/base/base_template.rb", "lib/base/configuration.rb", "lib/base/generator.rb", "lib/base/graph.rb", "lib/base/md5_tracker.rb", "lib/base/report.rb", "lib/generators/churn.rb", "lib/generators/flay.rb", "lib/generators/flog.rb", "lib/generators/rcov.rb", "lib/generators/reek.rb", "lib/generators/roodi.rb", "lib/generators/saikuro.rb", "lib/generators/stats.rb", "lib/graphs/flay_grapher.rb", "lib/graphs/flog_grapher.rb", "lib/graphs/rcov_grapher.rb", "lib/graphs/reek_grapher.rb", "lib/graphs/roodi_grapher.rb", "lib/metric_fu.rb", "lib/templates/awesome/awesome_template.rb", "lib/templates/awesome/churn.html.erb", "lib/templates/awesome/default.css", "lib/templates/awesome/flay.html.erb", "lib/templates/awesome/flog.html.erb", "lib/templates/awesome/index.html.erb", "lib/templates/awesome/layout.html.erb", "lib/templates/awesome/rcov.html.erb", "lib/templates/awesome/reek.html.erb", "lib/templates/awesome/roodi.html.erb", "lib/templates/awesome/saikuro.html.erb", "lib/templates/awesome/stats.html.erb", "lib/templates/standard/churn.html.erb", "lib/templates/standard/default.css", "lib/templates/standard/flay.html.erb", "lib/templates/standard/flog.html.erb", "lib/templates/standard/index.html.erb", "lib/templates/standard/rcov.html.erb", "lib/templates/standard/reek.html.erb", "lib/templates/standard/roodi.html.erb", "lib/templates/standard/saikuro.html.erb", "lib/templates/standard/standard_template.rb", "lib/templates/standard/stats.html.erb", "tasks/metric_fu.rake", "vendor/_fonts/monaco.ttf", "vendor/saikuro/saikuro.rb"]

  # Dir['spec/**/*.*']
  s.test_files = ["spec/base/base_template_spec.rb", "spec/base/configuration_spec.rb", "spec/base/generator_spec.rb", "spec/base/md5_tracker_spec.rb", "spec/base/report_spec.rb", "spec/generators/churn_spec.rb", "spec/generators/flay_spec.rb", "spec/generators/flog_spec.rb", "spec/generators/reek_spec.rb", "spec/generators/saikuro_spec.rb", "spec/generators/stats_spec.rb", "spec/graphs/flog_grapher_spec.rb", "spec/resources/saikuro/app/controllers/sessions_controller.rb_cyclo.html", "spec/resources/saikuro/app/controllers/users_controller.rb_cyclo.html", "spec/resources/saikuro/index_cyclo.html", "spec/resources/saikuro_sfiles/thing.rb_cyclo.html", "spec/spec.opts", "spec/spec_helper.rb"]
  
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["HISTORY", "Manifest.txt", "README"]

  s.add_dependency("flay", [">= 1.2.1"])
  s.add_dependency("flog", [">= 2.1.0"])
  s.add_dependency("relevance-rcov", [">= 0.8.3.3"])
  s.add_dependency("mojombo-chronic", [">= 0.3.0"])
  s.add_dependency("topfunky-gruff", [">= 0.3.5"])
end
