# coding: utf-8
require 'rubygems'
require 'rake'
require 'lib/metric_fu'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "yabawock-metric_fu"
    gem.summary = %Q{A fistful of code metrics, with awesome templates and graphs}
    gem.description = %Q{Code metrics from Flog, Flay, RCov, Saikuro, Churn, Reek, Roodi and Rails' stats task}
    gem.email = "yabawock@gmail.com"
    gem.homepage = "http://metric-fu.rubyforge.org/"
    gem.authors = ["Morton Jonuschat", "Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes", "Nick Quaranto", "Édouard Brière", "Carl Youngblood"]
    gem.add_dependency("flay", [">= 1.2.1"])
    gem.add_dependency("flog", ["= 2.2.0"])
    gem.add_dependency("rcov", [">= 0.8.3.3"])
    gem.add_dependency("chronic", [">= 0.2.3"])
    gem.add_dependency("churn", [">= 0.0.7"])
    gem.add_dependency("yabawock-Saikuro", [">= 1.2.0"])
    gem.add_dependency("activesupport", [">= 2.2.3"])
    gem.add_development_dependency("rspec", [">= 1.2.9"])
    gem.add_development_dependency("test-construct", [">= 1.2.0"])
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "yabawock-metric_fu #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

MetricFu::Configuration.run do |config|
  config.template_class = AwesomeTemplate
end
