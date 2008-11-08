Gem::Specification.new do |s|
  s.name = "metric_fu"
  s.version = "0.8.0"
  s.summary = "Generates project metrics using Flog, RCov, Saikuro and more"
  s.email = "jake.scruggs@gmail.com"
  s.homepage = "http://metric-fu.rubyforge.org/"
  s.description = "Gives you a fist full of code metrics"
  s.has_rdoc = true
  s.authors = ["Jake Scruggs", "Sean Soper"]
  s.files = ["History.txt", "Manifest.txt", "metric_fu.gemspec", "MIT-LICENSE", "README", "TODO.txt"]
  s.files << Dir['lib/**/*']
  s.test_files = ["spec"]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README"]
  s.add_dependency("flog", ["> 0.0.0"])
  s.add_dependency("rcov", ["> 0.0.0"])
end