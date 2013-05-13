How to contribute:

## Bug reports / Issues

  * Is something broken or not working as expected? Check for an existing issue or [create a new one](https://github.com/metricfu/metric_fu/issues/new)
  * See [Quick guide to writing good bug reports](https://github.com/metricfu/metric_fu/wiki/Issues:-Quick-guide-to-writing-good-bug-reports)

## Code

1. Clone the repo: `git clone git://github.com/metricfu/metric_fu.git && cd metric_fu`
2. Install the gem dependencies: `bundle install`
3. Make the changes you want and back them up with tests.
  * Run the tests (`bundle exec rake`)
  * Run metric_fu on itself (`bundle exec rake metrics:all`)
4. Update the HISTORY.md file with your changes and give yourself credit
5. Commit and create a pull request with details as to what has been changed and why
  * Use well-described, small (atomic) commits.
  * Include links to any relevant github issues.
  * *Don't* change the VERSION file.
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
