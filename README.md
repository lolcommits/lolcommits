By default, the lolimages are stored by a Github style SHA in a `.lolcommits` directory within your repository. (You probably will want to add it to your global `.gitignore`, unless your intention is to keep them in source control directly which is even more awesome.)

### Prerequisites

- ImageMagick (`brew install imagemagick` assuming you are on a mac using homebrew)
- RMagick and ruby-git gems (`bundle install` when in this directory)
- ImageSnap (included)

### Installation

#### The boring way
Copy `bin/imagesnap` to somewhere in your `$PATH`.  Make `lolcommit.rb` a post-commit hook in the repo you want it to run for.

#### The awesome way (for multiple repos)
Run `rake install`. This will do the following:

- Copy `imagesnap` to `/usr/local/bin`
- Clone and install the git-hooks project (adding it to `/usr/local/bin`)
- Creates your global user `~/.git_hooks` and gives you a few directories to start (pre-commit, commit-msg, and post-commit).
- Copies the main script here (`lolcommit.rb`) to your new `~./git_hooks/post-commit` directory.

Once this is done, simply run `git hooks --install` in any repository you want to use this in.

This installs git-hooks which gives you a global user hooks directory so you can set up other stuff easily as well.  See their README for more details.