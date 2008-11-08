Gem::Specification.new do |s|
  s.name = "metric_fu"
  s.version = "0.8.1"
  s.summary = "A fistful of code metrics"
  s.email = "jake.scruggs@gmail.com"
  s.homepage = "http://metric-fu.rubyforge.org/"
  s.description = "Code metrics from Flog, RCov, Saikuro, Churn, and Rails' stats task"
  s.authors = ["Jake Scruggs", "Sean Soper", "Andre Arko"]
  
  s.files = Dir['lib/**/*.rb'] + ["History.txt", "README", "Rakefile", "MIT-LICENSE", "TODO.txt"]
  
  s.test_files = Dir['spec/**/*.rb']
  
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["History.txt", "README"]
  
  s.add_dependency("flog", [">= 1.2.0"])
  s.add_dependency("rcov", [">= 0.8.1"])
end