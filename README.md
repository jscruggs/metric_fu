This is the official repository for metric_fu.  The original repository by Jake Scruggs at [https://github.com/jscruggs/metric_fu](https://github.com/jscruggs/metric_fu) [has been deprecated.](http://jakescruggs.blogspot.com/2012/08/why-i-abandoned-metricfu.html).

__Installation__

    gem install metric_fu

If you have trouble installing the gem, try adding metric_fu to your Gemfile. You may also want to file a ticket on the issues page.

See documentation on the rubyforge page for how to customize your metrics. Otherwise, all current information is either in this repo or on the wiki.

By default, you can run all metrics from the root of an app with the command `metric_fu -r`

You may also wish to use the `metricfu-metrical` fork, which will probably be merged in at some point.

__Compatibility__

It is currently testing on MRI 1.8.7, 1.9.2, and 1.9.3

* The `japgolly-Saikuro` fork and `metric_fu-roodi` fork are a part of an attempt to get metric_fu working in a modern Ruby environment, specifically compatibility with Ruby 1.9 and Bundler.

* Until we can upgrade to the latest RubyParser, metric_fu will fail on parsing some 1.9 code, e.g. the new hash syntax, and possibly have issues with encodings

* Please note that rake version 10.0.2 cannot be used, whereas 0.8.7 through 0.9.2.2 do work.


__CI Build Status__

[![Build Status](https://secure.travis-ci.org/metricfu/metric_fu.png)](http://travis-ci.org/metricfu/metric_fu)

This project runs [travis-ci.org](http://travis-ci.org)

__Code Quality__

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/metricfu/metric_fu)

This project runs [https://codeclimate.com/](https://codeclimate.com/)

__Gem Dependencies__

[![Dependency Status](https://gemnasium.com/metricfu/metric_fu.png)](https://gemnasium.com/metricfu/metric_fu)

This project runs [https://gemnasium.com/metricfu](https://gemnasium.com/metricfu)

===============================================================================

For documentation, in addition to this file and the wiki, there is some useful-but-out-of-date documentation about configuring metric_fu at http://metric-fu.rubyforge.org/ and a change log in the the HISTORY file.

How to contribute:

1. Fork metric_fu on github.
2. bundle install
3. Run the tests ('bundle exec rake')
4. Run metric_fu on itself ('bundle exec metric_fu -r')
5. Make the changes you want and back them up with tests.
6. Make sure two important rake tests still run ('bundle exec rake' and 'bundle exec rake metrics:all')
7. Commit and send me a pull request with details as to what has been changed.

Extra Credit:

1. Make sure your changes work in 1.8.7, Ruby Enterprise Edition, and 1.9.3 (Hint use 'rvm' to help install multiple rubies)
2. Update the documentation here or the rubyforge web page inside the `'home_page'` folder
3. Update the History and give yourself credit.


The more of the above steps you do the easier it will be for me to merge in which will greatly increase you chances of getting your changes accepted.

Also see [Quick guide to writing good bug reports](https://github.com/metricfu/metric_fu/wiki/Issues:-Quick-guide-to-writing-good-bug-reports)

Resources:

* Github: http://github.com/metricfu/metric_fu
* Issue Tracker: http://github.com/metricfu/metric_fu/issues
* Google Group: http://groups.google.com/group/metric_fu
* Historical Homepage: http://metric-fu.rubyforge.org/

Original Resources:

* Github: http://github.com/jscruggs/metric_fu
* Issue Tracker: http://github.com/jscruggs/metric_fu/issues
* Jake's Blog: http://jakescruggs.blogspot.com/
