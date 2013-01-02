# TODO list


## Features

* Look into removing rcov and churn, and adding laser, brakeman, and/or cane
* Add configurable logger to all output streams
* Color code flog results with scale from: http://jakescruggs.blogspot.com/2008/08/whats-good-flog-score.html
* Make running metric_fu on metric_fu less embarrassing
* Load all gems at config time so you fail fast if one is missing

## Testing

* Determine how to test metric_fu against codebases that are not metric_fu, to ensure it works on most applications

## Bugs / Fixes

* Fix occasional gem install metric_fu failures such as with ripper in Ruby 1.9
* Fork roodi and correct the yaml
* See https://github.com/metricfu/metric_fu/issues/2 about updating gems

## Ruby 1.9 compatibility

* Consider RUBYOPT='-rpsych' e.g. from https://github.com/jscruggs/metric_fu/pull/77
* Look into using the sexp_processor for ruby parsing in brakeman https://github.com/presidentbeef/brakeman/blob/cdc85962d589fb37e37ed53333bb0b7bd913e028/lib/ruby_parser/bm_sexp_processor.rb

## Misc

* Update the homepage http://metric-fu.rubyforge.org/

