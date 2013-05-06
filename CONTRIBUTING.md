How to contribute:

## Code 

1. Clone the repo: `git clone git://github.com/metricfu/metric_fu.git && cd metric_fu`
2. Install the gem dependencies: `bundle install`
3. Make the changes you want and back them up with tests.
  * Run the tests ('bundle exec rake')
  * Run metric_fu on itself ('bundle exec rake metrics:all')
4. Update the HISTORY.md file with your changes and give yourself credit
5. Commit and create a pull request with details as to what has been changed, including links to any relevant issues.
  * Use well-described, small-commits, and describe any relevant details in your pull request to make it easier for me to merge and greatly increase you chances of getting your changes accepted.
  * *Don't* change the VERSION file.
  * Also see [Quick guide to writing good bug reports](https://github.com/metricfu/metric_fu/wiki/Issues:-Quick-guide-to-writing-good-bug-reports)
6. Extra Credit: [Confirm it runs and tests pass on the rubies specified in the travis config](.travis.yml). I will otherwise confirm it runs on these.

How I handle pull requests:

* If the tests pass and the pull request looks good, I will merge it.
* If the pull request needs to be changed, 
  * you can change it by updating the branch you generated the pull request from
    * either by adding more commits, or
    * by force pushing to it
  * I can make any changes myself and manually merge the code in.

## Documentation

* If relevant, you may update [the metric_fu website](https://github.com/metricfu/metricfu.github.com) in a separate pull request to that repo
* Update the wiki
