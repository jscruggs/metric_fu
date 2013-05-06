# MetricFu [![Gem Version](https://badge.fury.io/rb/metric_fu.png)](http://badge.fury.io/rb/metric_fu) [![Build Status](https://travis-ci.org/metricfu/metric_fu.png?branch=master)](http://travis-ci.org/metricfu/metric_fu) [![Code Climate](https://codeclimate.com/github/metricfu/metric_fu.png)](https://codeclimate.com/github/metricfu/metric_fu) [![Dependency Status](https://gemnasium.com/metricfu/metric_fu.png)](https://gemnasium.com/metricfu/metric_fu)

## Metrics

* [Cane](https://rubygems.org/gems/cane), [Source](http://github.com/square/cane)
* [Churn](https://rubygems.org/gems/churn), [Source](http://github.com/danmayer/churn)
* [Flog](https://rubygems.org/gems/flog), [Source](https://github.com/seattlerb/flog)
* [Flay](https://rubygems.org/gems/flay), [Source](https://github.com/seattlerb/flay)
* [Reek](https://rubygems.org/gems/reek) [Source](https://github.com/troessner/reek)
* [Roodi](https://rubygems.org/gems/metric_fu-roodi), [Source](https://github.com/metricfu/roodi)
* [Saikuro](https://rubygems.org/gems/japgolly-Saikuro), [Source](https://github.com/japgolly/Saikuro)
* Rails-only
  * [Rails Best Practices](https://rubygems.org/gems/rails_best_practices), [Source](https://github.com/railsbp/rails_best_practices)
  * Rails `rake stats` task (see [gem](https://rubygems.org/gems/code_statistics), [Source](https://github.com/danmayer/code_statistics) )
* Test Coverage
  * 1.9: [SimpleCov](http://rubygems.org/gems/simplecov) and [SimpleCov-Rcov-Text](http://rubygems.org/gems/simplecov-rcov-text)
  * 1.8 [Rcov](http://rubygems.org/gems/rcov)
* Hotspots (a meta-metric of the above)

## Installation

    gem install metric_fu

If you have trouble installing the gem, try adding metric_fu to your Gemfile. You may also want to file a ticket on the issues page.

See documentation on the rubyforge page for how to customize your metrics. Otherwise, all current information is either in this repo or on the wiki.

## Usage

By default, you can run all metrics from the root of an app with the command `metric_fu -r`

See `metric_fu --help` for more options

## Compatibility

* It is currently testing on MRI 1.9.2, 1.9.3 and 2.0.0. Ruby 1.8 is no longer supported due to the cane library.

* For 1.8.7 support, see version 3.0.0 for partial support, or 2.1.3.7.18.1 (where [Semantic Versioning](http://semver.org/) goes to die)

* The `japgolly-Saikuro` fork and `metric_fu-roodi` fork are a part of an attempt to get metric_fu working in a modern Ruby environment, specifically compatibility with Ruby 1.9 and Bundler.

* metric_fu no longer runs rcov itself. You may still use rcov metrics as documented below

* The Cane, Flog, and Rails Best Practices metrics are disabled in non-MRI rubies as they depend on ripper

## Documentation

* Cane code quality threshold checking is not included in the hotspots report

### Configuration

see the .metrics file

### Using Coverage Metrics

in your .metrics file add the below to run pre-generated metrics

    MetricFu::Configuration.run do |config|
      coverage_file = File.expand_path("coverage/rcov/rcov.txt", Dir.pwd)
      config.add_metric(:rcov)
      config.add_graph(:rcov)
      config.configure_metric(:rcov, {:external => coverage_file})
    end

if you want metric_fu to actually run rcov itself (1.8 only), just add

    MetricFu.run_rcov

#### Rcov metrics with Ruby 1.8

To generate the same metrics metric_fu has been generating run from the root of your project before running metric_fu

    RAILS_ENV=test rcov $(ruby -e "puts Dir['{spec,test}/**/*_{spec,test}.rb'].join(' ')") --sort coverage --no-html --text-coverage --no-color --profile --exclude-only '.*' --include-file "\Aapp,\Alib" -Ispec >> coverage/rcov/rcov.txt

#### Simplecov metrics with Ruby 1.9 and 2.0

Add to your Gemfile or otherwise install

    gem 'simplecov'
    # https://github.com/kina/simplecov-rcov-text
    gem 'simplecov-rcov-text'

Modify your spec_helper as per the SimpleCov docs and run your tests before running metric_fu

    #in your spec_helper
    require 'simplecov'
    require 'simplecov-rcov-text'
    SimpleCov.formatter = SimpleCov::Formatter::RcovTextFormatter
    SimpleCov.start
    # SimpleCov.start 'rails'

### Historical

There is some useful-but-out-of-date documentation about configuring metric_fu at http://metric-fu.rubyforge.org/ and a change log in the the HISTORY file.

## Contributions

See the TODO for some ideas

See CONTRIBUTING for how to contribute

## Resources:

This is the official repository for metric_fu.  The original repository by Jake Scruggs at [https://github.com/jscruggs/metric_fu](https://github.com/jscruggs/metric_fu) [has been deprecated.](http://jakescruggs.blogspot.com/2012/08/why-i-abandoned-metricfu.html).

* Github: http://github.com/metricfu/metric_fu
* Issue Tracker: http://github.com/metricfu/metric_fu/issues
* Google Group: http://groups.google.com/group/metric_fu
* Historical Homepage: http://metric-fu.rubyforge.org/

### Original Resources:

* Github: http://github.com/jscruggs/metric_fu
* Issue Tracker: http://github.com/jscruggs/metric_fu/issues
* Jake's Blog: http://jakescruggs.blogspot.com/
