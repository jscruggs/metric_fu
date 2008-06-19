Gem::Specification.new do |s|
  s.name = "metricks"
  s.version = "0.4.1"
  s.date = "2008-06-13"
  s.summary = "Generates project metrics using Flog, RCov, Saikuro and more"
  s.email = "sean.soper@gmail.com"
  s.homepage = "http://github.com/revolutionhealth/metricks"
  s.description = "Metricks is a fork of the metric_fu project and adds support for additional code analysis tools"
  s.has_rdoc = true
  s.authors = ["Sean Soper"]
  s.files = %w(History.txt Manifest.txt metricks.gemspec MIT-LICENSE README TODO.txt) + Dir.glob("{lib,test}/**/*")
  s.test_files = ["test/test_md5_tracker.rb"]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README"]
  # s.add_dependency("mime-types", ["> 0.0.0"])
end