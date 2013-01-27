# TODO list

## Before next release

* Move code that references rcov out of

    lib/metrics/hotspots/hotspot_analyzer.rb
    lib/reporting/graphs/engines/bluff.rb
    lib/reporting/graphs/engines/gchart.rb
    lib/reporting/templates/awesome/css/default.css
    lib/reporting/templates/awesome/index.html.erb
    lib/reporting/templates/standard/default.css
    lib/reporting/templates/standard/index.html.erb

* Move code that references flog out of

    lib/configuration.rb
    lib/metrics/hotspots/analysis/code_issue.rb
    lib/metrics/hotspots/analysis/scoring_strategies.rb
    lib/metrics/hotspots/hotspot_analyzer.rb
    lib/reporting/graphs/engines/bluff.rb
    lib/reporting/graphs/engines/gchart.rb
    lib/reporting/templates/awesome/index.html.erb
    lib/reporting/templates/standard/index.html.erb

* Move code that references flay out of

    lib/metrics/generator.rb
    lib/metrics/hotspots/analysis/code_issue.rb
    lib/metrics/hotspots/hotspot_analyzer.rb
    lib/reporting/graphs/engines/bluff.rb
    lib/reporting/graphs/engines/gchart.rb
    lib/reporting/templates/awesome/index.html.erb
    lib/reporting/templates/standard/index.html.erb

* Move code that references churn out of

    lib/metrics/hotspots/analysis/code_issue.rb
    lib/metrics/hotspots/hotspot_analyzer.rb
    lib/metrics/hotspots/init.rb
    lib/reporting/templates/awesome/index.html.erb
    lib/reporting/templates/standard/index.html.erb

* Move code that references rails_best_practices out of

    lib/metrics/hotspots/analysis/code_issue.rb
    lib/metrics/hotspots/hotspot_analyzer.rb
    lib/reporting/graphs/engines/bluff.rb
    lib/reporting/graphs/engines/gchart.rb
    lib/reporting/templates/awesome/index.html.erb
    lib/reporting/templates/standard/index.html.erb


* Move code that references reek out of

    lib/data_structures/location.rb
    lib/metrics/hotspots/analysis/code_issue.rb
    lib/metrics/hotspots/analysis/scoring_strategies.rb
    lib/metrics/hotspots/hotspot_analyzer.rb
    lib/reporting/graphs/engines/bluff.rb
    lib/reporting/graphs/engines/gchart.rb
    lib/reporting/templates/awesome/index.html.erb
    lib/reporting/templates/standard/index.html.erb


* Move code that references roodi out of

    lib/metrics/hotspots/analysis/code_issue.rb
    lib/metrics/hotspots/hotspot_analyzer.rb
    lib/reporting/graphs/engines/bluff.rb
    lib/reporting/graphs/engines/gchart.rb
    lib/reporting/templates/awesome/index.html.erb
    lib/reporting/templates/standard/index.html.erb

* Move code that references saikuro out of

    lib/metrics/hotspots/analysis/code_issue.rb
    lib/metrics/hotspots/hotspot_analyzer.rb
    lib/reporting/templates/awesome/index.html.erb
    lib/reporting/templates/standard/index.html.erb

* Move code that references stats out of

lib/reporting/graphs/engines/bluff.rb
lib/reporting/graphs/engines/gchart.rb
lib/reporting/templates/awesome/index.html.erb
lib/reporting/templates/standard/index.html.erb

* Review how metric_fu uses each tools to generate metrics, e.g. by shelling out commands, rake task, modifying the output, etc.

* Change MetricFu.report.add(metric) to e.g. MetricFu.generate_report(metric) to make clear that this actually runs the tool

* Allow the coverage task to specify the command it runs plus any flags (see bundler/capistrano options)

* Test against a rails app

## Features

* Remove rcov by default
* Either allow user to define a command to run a coverage task or supply a directory with coverage results.   We can't predict every test setup to run coverage correctly, but we can analyze results.
* Look into getting everything to run on RubyParser ~> 3
* Look into adding
  * https://github.com/metricfu/code_statistics
  * brakeman https://github.com/metricfu/brakeman
  * cane https://github.com/square/cane
  * laser https://github.com/metricfu/laser
* Add configurable logger to all output streams
* Allow command-line metric_fu to accept parameters, and especially output its version
* Color code flog results with scale from: http://jakescruggs.blogspot.com/2008/08/whats-good-flog-score.html
* Make running metric_fu on metric_fu less embarrassing
* Load all gems at config time so you fail fast if one is missing
* Refactor the hotspots code


## Testing

* Determine how to test metric_fu against codebases that are not metric_fu, to ensure it works on most applications
  * This is especially true for rails applications
* <strike>Re-organize test files structure to align with changed structure of library files</strike>
* Remove / Modify Devver code from the generators/hotspots_spec and base/hotspot_analzyer_spec
* <strike>Don't leave around test artifacts such as the folders './foo' and './is set'</strike>

## Bugs / Fixes

* Fix occasional gem install metric_fu failures such as with ripper in Ruby 1.9
* <strike>Fork roodi and correct the yaml</strike>
* See https://github.com/metricfu/metric_fu/issues/2 about updating gems

## Ruby 1.9 compatibility

* Consider `RUBYOPT='-rpsych'` e.g. from https://github.com/jscruggs/metric_fu/pull/77
* Look into using the sexp_processor for ruby parsing in brakeman https://github.com/presidentbeef/brakeman/blob/cdc85962d589fb37e37ed53333bb0b7bd913e028/lib/ruby_parser/bm_sexp_processor.rb

## Misc

* Determine if CodeIssue is used, else remove it
* Remove references to Ruport from the Devver / Caliper code
* Update or move the homepage http://metric-fu.rubyforge.org/
* Is there any reason not to remove the Manifest.txt?
* See other documentation code for examples to improve ours:
  * https://github.com/charliesome/better_errors/blob/master/CONTRIBUTING.md
  * https://github.com/charliesome/better_errors/blob/master/README.md
* Other intersting libraries to consider:
  * https://gist.github.com/4562865 for generating Flog on ERB templates by jamesmartin
  * https://github.com/chad/turbulence churn and complexity (flog)
  * https://github.com/vinibaggio/discover-unused-partials
  * https://github.com/metricfu/heckle (test mutation)
  * https://github.com/mbj/mutant (test mutation)
  * https://github.com/metricfu/gauntlet
  * https://github.com/metricfu/repodepot-ruby https://twitter.com/jakescruggs/status/70521977303076865
  * https://github.com/eladmeidar/rails_indexes
  * https://github.com/trptcolin/consistency_fail 
  * https://github.com/thoughtbot/appraisal
  * https://github.com/jenkinsci/rubymetrics-plugin
  * https://github.com/holman/hopper
