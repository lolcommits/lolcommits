### Contributing

Pull Requests are welcome! To start helping out on lolcommits:

[Fork](https://guides.github.com/activities/forking/) then clone the repository:

    git clone git@github.com:your-username/lolcommits.git

Create your feature branch:

    git checkout -b my-new-feature

When you are happy with your change, run the full test suite:

    bundle exec rake

Please ensure nothing is broken. It'd be awesome if you manually tested for
regressions as well (since the test suite is far from complete).

This default rake task uses [RuboCop](https://github.com/bbatsov/rubocop) to
ensure Ruby style guidelines. If you want to run tests before conforming to this
to verify functionality, just run `rake test` and `rake features` manually.

With a passing test suite, commit your changes, push and submit a new [Pull
Request](https://github.com/mroth/lolcomits/compare/):

    git commit -am 'Added some feature'
    git push origin my-new-feature

At this point you'll be waiting for one of our maintainers to review it. We will
try to reply to new Pull Requests within a few days. We might suggest some
changes, improvements or alternatives. To increase the chance that your pull
request gets accepted:

* Explain what your are doing (and why) in your Pull Request description.
* If you are fixing an
  [issue](https://github.com/mroth/lolcomits/issues), link to
  it in your description and [mention
  it](https://help.github.com/articles/closing-issues-via-commit-messages/) in
  the commit message.
* Write a good [commit
  message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).
* Write tests.

