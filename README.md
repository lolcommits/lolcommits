# git + webcam = lol

Takes a snapshot with your Mac's built-in iSight webcam every time you git commit code, and archives a lolcat style image with it.

By default, the lolimages are stored by a Github style short SHA in a `~/.lolcommits` directory created for you.

## Prerequisites

- ImageMagick (`brew install imagemagick` assuming you are on a mac using [Homebrew](http://mxcl.github.com/homebrew/))
- RMagick and ruby-git gems (`bundle install` when in this directory)
- [ImageSnap](http://www.iharder.net/current/macosx/imagesnap/) (included)

## Installation

### The boring way
Copy `bin/imagesnap` to somewhere in your `$PATH`.  Make `lolcommit.rb` a post-commit hook in the repo you want it to run for.

### The awesome way (works for multiple repos)
Run `rake install`. This will do the following:

- Copy `imagesnap` to `/usr/local/bin`
- Clone and install [the git-hooks project](https://github.com/icefox/git-hooks) (adding it to `/usr/local/bin`)
- Creates your global user `~/.git_hooks` and gives you a few directories to start (pre-commit, commit-msg, and post-commit).
- Copies the main script here (`lolcommit.rb`) to your new `~/.git_hooks/post-commit` directory.
- Uses `bundler` to install any uninstalled Gem dependencies (assuming bundler is installed, manually `gem install bundler` if not, we don't auto-install it to be polite.)
- Uses `homebrew` to install ImageMagick (assuming Homebrew is installed, we don't auto-install it here to be polite.)

Once this is done, simply run `git hooks --install` while in any repository you want to use this in.

This installs [git-hooks](https://github.com/icefox/git-hooks) which gives you a global user hooks directory so you can set up other stuff easily as well.  See their README for more details.

If you don't want to use `/usr/local/bin` you can provide a different
dir running `LOCAL_BINDIR=/your/path/of/choice rake install`

## Sample images
Please add your own lolcommit to these samples!  Just fork this repo, add it to this section of the README, and send me a pull request.
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample2.jpg" />
&nbsp;
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample5.jpg" />
<br/>
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample4.jpg" />
&nbsp;
