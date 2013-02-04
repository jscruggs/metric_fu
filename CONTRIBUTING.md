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
