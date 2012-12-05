# -*- coding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "bf4-metric_fu"
  s.platform    = Gem::Platform::RUBY
  s.version     = "2.1.3.4"
  s.summary     = "A fistful of code metrics, with awesome templates and graphs"
  s.email       = "github@benjaminfleischer.com"
  s.homepage    = "http://github.com/bf4/metric_fu"
  s.description = "Code metrics from Flog, Flay, Simplecov-RCov, Saikuro, Churn, Reek, Roodi, Rails' stats task and Rails Best Practices"
  s.authors     = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes", "Nick Quaranto", "Édouard Brière", "Carl Youngblood", "Richard Huang", "Dan Mayer", "Benjamin Fleischer"]
  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"
  # git_files            = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ } rescue ''
  # s.files              = git_files
  # s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.license     = 'MIT'

  s.files = ["README.md","HISTORY","TODO","MIT-LICENSE","Rakefile"]

  s.files +=     Dir['lib/**/*.*']
  s.test_files = Dir['spec/**/*.*']

  {
    "flay"                  => ["= 1.2.1"],
    "flog"                  => ["= 2.3.0"],
    "reek"                  => ["= 1.2.12"],
    "roodi"                 => ["= 2.1.0"],
    "rails_best_practices"  => ["~> 0.6"],
    "churn"                 => ["= 0.0.7"],
    "sexp_processor"        => ["~> 3.0.3"], # required because of churn.
    "chronic"               => ["= 0.2.3"], # required by churn
    "main"                  => ["= 4.7.1"], # required by churn
    "activesupport"         => [">= 2.0.0"], # ok
    # "syntax"                => ["= 1.0.0"],
    "coderay"               => [],
    "fattr"                 => ["= 2.2.1"],
    "arrayfields"           => [" =4.7.4"],
    "map"                   => [" =6.2.0"],
    "bluff"                 => [],
    "googlecharts"          => []
  }.each do |gem, version|
    if version == []
      s.add_dependency(gem)
    else
      s.add_dependency(gem,version)
    end
  end
  # string comparison ftw
  if RUBY_VERSION < '1.9'
    s.add_dependency("ripper",[" =1.0.5"])
    s.add_dependency("rcov", ["~> 0.8"])
    s.add_dependency("Saikuro", ["= 1.1.0"])
  else
    s.add_dependency("rcov", ["~> 0.8"])
    s.add_dependency("japgolly-Saikuro", ">= 1.1.1.0")
    # still using rcov in ruby 1.9 till some errors are fleshed out
    # s.add_dependency("simplecov", [">= 0.5.4"])
    # s.add_dependency("simplecov-rcov", [">= 0.2.3"])
  end


  s.add_development_dependency("rake", '<=0.9.2')
  s.add_development_dependency("rspec", ["= 1.3.0"])
  s.add_development_dependency("test-construct", [">= 1.2.0"])
  s.add_development_dependency("googlecharts")
  s.require_paths = ["lib"]
end

