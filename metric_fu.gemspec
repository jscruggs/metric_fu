# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'metric_fu/version'

Gem::Specification.new do |s|
  s.name        = "metric_fu"
  s.platform    = Gem::Platform::RUBY
  s.version     = MetricFu::VERSION
  s.summary     = "A fistful of code metrics, with awesome templates and graphs"
  s.email       = "github@benjaminfleischer.com"
  s.homepage    = "http://github.com/metricfu/metric_fu"
  s.description = "Code metrics from Flog, Flay, RCov, Saikuro, Churn, Reek, Roodi, Rails' stats task and Rails Best Practices"
  s.authors     = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes", "Nick Quaranto", "Édouard Brière", "Carl Youngblood", "Richard Huang", "Dan Mayer", "Benjamin Fleischer"]
  s.rubyforge_project = 'metric_fu'
  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"
  s.files              = `git ls-files`.split($\)
  s.test_files         =  s.files.grep(%r{^(test|spec|features)/})
  s.executables        =  s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.license     = 'MIT'

  {
    "rails_best_practices"  => ["= 1.13.2"],
    "rcov"                  => ["~> 0.8"],
    # still using rcov in ruby 1.9 till some errors are fleshed out
    # "simplecov"             => [">= 0.5.4"],
    # "simplecov-rcov"        => [">= 0.2.3"],
    "japgolly-Saikuro"      => [">= 1.1.1.0"],
    "metric_fu-roodi"       => [">= 2.2.0"],
    "flay"                  => ["= 2.0.1"],
    "flog"                  => ["= 3.2.0"],
    "reek"                  => ["= 1.3"],
    "churn"                 => ["= 0.0.28"],
      # specifying dependencies for flay, reek, churn, and flog
      "ruby_parser"           => ["~> 3.0", ">= 3.0.4"],
      "sexp_processor"        => ["~> 4.0"],
      "ruby2ruby"             => ["= 2.0.1"],
    "activesupport"         => [">= 2.0.0"], # ok
    "coderay"               => [],
    "fattr"                 => ["= 2.2.1"],
    "arrayfields"           => ["= 4.7.4"],
    "map"                   => ["= 6.2.0"],
    "bluff"                 => [],
    "googlecharts"          => []
  }.each do |gem, version|
    if version == []
      s.add_runtime_dependency(gem)
    else
      s.add_runtime_dependency(gem,version)
    end
  end

end

