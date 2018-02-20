# lolcommits
> git-based selfies for software developers

lolcommits takes a snapshot with your webcam every time you git commit code, and
archives a lolcat style image with it. Git blame has never been so much fun.

By default, the lol images are stored by a Github style short SHA in a
`~/.lolcommits` directory created for you.

[![Gem Version](https://badge.fury.io/rb/lolcommits.svg)](https://rubygems.org/gems/lolcommits)
[![Build Status](https://travis-ci.org/mroth/lolcommits.svg?branch=master)](https://travis-ci.org/mroth/lolcommits)
[![Dependency Status](https://gemnasium.com/mroth/lolcommits.svg)](https://gemnasium.com/mroth/lolcommits)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/mroth/lolcommits.svg)](https://codeclimate.com/github/mroth/lolcommits/maintainability)
[![Test Coverage](https://img.shields.io/codeclimate/c/mroth/lolcommits.svg)](https://codeclimate.com/github/mroth/lolcommits/test_coverage)

## Sample images

<img src="https://lolcommits.github.io/assets/img/gallery.jpeg" />

Please add your own lolcommit to the [People Using
Lolcommits](https://github.com/mroth/lolcommits/wiki/Lolcommits-from-around-the-world%21)
page on our wiki!


## Requirements

* Ruby >= 2.0.0
* A webcam
* [ImageMagick](http://www.imagemagick.org)
* [ffmpeg](https://www.ffmpeg.org) (optional) for animated gif capturing


## Installation


### macOS

You'll need ImageMagick installed. [Homebrew](http://mxcl.github.com/homebrew/)
makes this easy.

	brew install imagemagick

Then install with:

	[sudo] gem install lolcommits

If you're using RVM (or rbenv), you can/should probably omit the sudo, but the
default macOS Ruby install usually requires it.

Lolcommits v0.8.1 was the last release to support Ruby < 2.0. If you'd like to
use older Rubies try:

    [sudo] gem install lolcommits --version 0.8.1   # for Ruby 1.9
    [sudo] gem install lolcommits --version 0.7.0   # for Ruby 1.8


### Linux

Install these dependencies using your package manager of choice, for example in
Ubuntu:

    sudo apt-get install mplayer imagemagick libmagickwand-dev

For Ubuntu 14.04 or newer, you need to manually install ffmpeg since it no
longer ships with the default Ubuntu sources ([downloads
here](http://ffmpeg.org/download.html)).

Then install with:

    gem install lolcommits

For more details, see [Installing on
Linux](https://github.com/mroth/lolcommits/wiki/Installing-on-Linux).


### Windows - here be dragons!

It works, but you'll need some more detailed instructions to get the
dependencies installed. See the wiki page for [Installing on
Windows](https://github.com/mroth/lolcommits/wiki/Installing-on-Windows).


## Usage


### Enabling and basic usage

Within any git repository, simply run `lolcommits --enable`. From that point on,
any git commit will automatically trigger a lolcommit capture! By default, all
lolcommits are stored in `~/.lolcommits` and placed in a subdirectory by project
name, with a filename matching the commit hash.

Follow [these
steps](https://github.com/mroth/lolcommits/wiki/Enabling-Lolcommits-for-all-your-Git-Repositories)
to enable lolcommits across all your repos; using `git init` and the
`init.templatedir` setting.

Don't worry about it too much, half the fun of lolcommits is forgetting it's
installed!


### Other commands

OK, if you insist... Since you know about `--enable`, common sense suggests
there is also a repository specific `--disable`, hopefully you can guess what
that does.

Other handy common commands include `--last`, which will open for display your
most recent lolcommit, or `--browse`, which pops open the directory containing
all the lolcommit images for your current repository. You can always do `--help`
for a full list of available commands.

**NOTE**: Any extra arguments you pass with `--enable` are appended to the
git post-hook capture command. For example;

    lolcommits --enable --delay 5 --animate 4 --fork

Will configure capturing of an animated gif (4 secs) after a 5 sec delay in a
forked process. See the section below for more capture configuration options.


### Capture configuration options

lolcommits has some capture options for additional lulz. You can enable these
via environment variables like so;

* `LOLCOMMITS_DEVICE` set a webcam device - **except windows (non-animated) captures**
* `LOLCOMMITS_ANIMATE` (in seconds) set time for capturing an animated gif -
  **requires ffmpeg**
* `LOLCOMMITS_DELAY` (in seconds) set delay time before capturing (for slow
  webcams to warmup)
* `LOLCOMMITS_FORK` fork lolcommit runner (capture command forks to a new
  process, speedily returning you to your terminal)
* `LOLCOMMITS_STEALTH` disable all notification messages when capturing
* `LOLCOMMITS_DIR` set the output directory used for all repositories (defaults
  to ~/.lolcommits)
* `LOLCOMMITS_CAPTURE_DISABLED` disables lolcommit capturing in the commit hook
  (when set as 'true')


Or they can be set with arguments to the capture command (located in your
repository's `.git/hooks/post-commit` file).

* `--device {name}` or `-d {name}`
* `--animate {seconds}` or `-a {seconds}`
* `--delay {seconds}` or `-w {seconds}`
* `--fork`
* `--stealth`

Use `lolcommits --devices` to list all attached video devices available for
capturing.

You can configure lolcommit text positions, font styles (type, size, color etc.)
or add a transparent overlay to your images. Simply configure the default
loltext plugin with this command:

    lolcommits --config -p loltext

To find out more about styling, read about the [loltext
options](https://github.com/mroth/lolcommits/wiki/Configure-Commit-Capturing#loltext-options).


### Animated Gif Capturing

Animated gifs can take a while to generate (depending on the number of seconds
you capture and the capabilities of your machine).
[ffmpeg](https://www.ffmpeg.org) is required and can be installed like so;

* Linux - [follow this guide](https://www.ffmpeg.org/download.html#build-linux)
* macOS - `brew install ffmpeg`
* Windows - [follow this guide](https://ffmpeg.org/download.html#build-windows)

To enable, just set the `LOLCOMMITS_ANIMATE` environment variable with the
number of seconds to capture. If you find animated capturing takes too long, try
setting `LOLCOMMITS_FORK=true`.

![Example animated lolcommit
gif](http://cdn2.usa.bugleblogs.com/blogs/000/000/003/de0eb9aa695.gif "Example
animated lolcommit gif")


### Plugins

A growing number of plugins are available, allowing you to transform or share
your lolcommits with others. The default plugin simply appends your commit
message and sha to the captured image. Others can post to Twitter, Tumblr (and
other services), or even translate your commit messages to
[lolspeak](http://www.urbandictionary.com/define.php?term=lolspeak). Check them
out on our [plugins
page](https://github.com/mroth/lolcommits/wiki/Configuring-Plugins).

To list all installed plugins use:

    lolcommits --plugins

Installed plugins can be easily enabled, configured or disabled with the
`--config` option:

    lolcommits --config
    # or
    lolcommits --config -p loltext

Interested in developing your own plugin? Follow [this simple
guide](https://github.com/lolcommits/lolcommits-sample_plugin#developing-your-own-plugin) at the
Lolcommits Sample Plugin README.


## Timelapse

Watch your face decay while you program, with an animated timelapse gif!

    lolcommits --timelapse
    # or for just today's lolcommits
    lolcommits --timelapse --period today

## Troubles?

Try our trouble-shooting [FAQ](https://github.com/mroth/lolcommits/wiki/FAQ), or
take a read through our [wiki](https://github.com/mroth/lolcommits/wiki). If you
think something is broken or missing, please raise a [Github
issue](https://github.com/mroth/lolcommits/issues) (and please check if we
haven't [already
addressed](https://github.com/mroth/lolcommits/issues?q=is%3Aissue+is%3Aclosed)
it).


## License

The program is available as open source under the terms of
[LGPL-3](https://opensource.org/licenses/LGPL-3.0).

