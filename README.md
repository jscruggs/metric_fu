This fork is intended to be a maintained version of metric_fu, as [the original version by Jake Scruggs has been abandoned.](http://jakescruggs.blogspot.com/2012/08/why-i-abandoned-metricfu.html). It is currently testing on MRI 1.8.7 and 1.9.3

At this time, the gem is published on rubygems.org as bf4-metric_fu

There is also a related bf4-metrical gem published

The japgolly-Saikuro fork is a part of an attempt to get metric_fu working in a modern

Please note that rake version 10.0.2 cannot be used, whereas 0.8.7 and 0.9.2 do work.

Ruby environment, specifically compatibility with Ruby 1.9 and Bundler.

__CI Build Status__

[![Build Status](https://secure.travis-ci.org/bf4/metric_fu.png)](http://travis-ci.org/bf4/metric_fu)

This project runs [travis-ci.org](http://travis-ci.org)

__Code Quality__

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/bf4/metric_fu)

This project runs [https://codeclimate.com/](https://codeclimate.com/)


===============================================================================

See http://metric-fu.rubyforge.org/ for documentation, or the HISTORY file for a change log.

How to contribute:

1. Fork metric_fu on github.
2. bundle install
3. Run the tests ('rake')
4. Run metric_fu on itself ('rake metrics:all')
5. Make the changes you want and back them up with tests.
6. Make sure two important rake tests still run ('rake' and 'rake metrics:all')
7. Commit and send me a pull request with details as to what has been changed.

Extra Credit:

1. Make sure your changes work in 1.8.7, Ruby Enterprise Edition, and 1.9.3 (Hint use 'rvm' to help install multiple rubies)
2. Update the documentation (web page inside the 'home_page' folder)
3. Update the History and give yourself credit.


The more of the above steps you do the easier it will be for me to merge in which will greatly increase you chances of getting your changes accepted.

Resources:

Github: http://github.com/bf4/metric_fu
Issue Tracker: http://github.com/bf4/metric_fu/issues
My Blog: http://benjaminfleischer.com

Original Resources:

Homepage: http://metric-fu.rubyforge.org/
Github: http://github.com/jscruggs/metric_fu
Google Group: http://groups.google.com/group/metric_fu
Issue Tracker: http://github.com/jscruggs/metric_fu/issues
My Blog: http://jakescruggs.blogspot.com/
