Gem::Specification.new do |s|
  s.name = "metric_fu"
  s.version = "0.7.0"
  s.date = "2008-09-11"
  s.summary = "Generates project metrics using Flog, RCov, Saikuro and more"
  s.email = "jake.scruggs@gmail.com"
  s.homepage = "http://metric-fu.rubyforge.org/"
  s.description = "Gives you a fist full of code metrics"
  s.has_rdoc = true
  s.authors = ["Jake Scruggs", "Sean Soper"]
  s.files = %w(History.txt Manifest.txt metric_fu.gemspec MIT-LICENSE README TODO.txt) + Dir.glob("{lib,test}/**/*")
  s.test_files = ["test/test_md5_tracker.rb"]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README"]
  # s.add_dependency("mime-types", ["> 0.0.0"])
end