# lolcommits (git + webcam = lol)

lolcommits takes a snapshot with your webcam every time you git commit code, and
archives a lolcat style image with it. Git blame has never been so much fun.

By default, the lol images are stored by a Github style short SHA in a
`~/.lolcommits` directory created for you.

[![Gem Version](https://badge.fury.io/rb/lolcommits.svg)](https://rubygems.org/gems/lolcommits)
[![Build Status](https://travis-ci.org/mroth/lolcommits.svg?branch=master)](https://travis-ci.org/mroth/lolcommits)
[![Dependency Status](https://gemnasium.com/mroth/lolcommits.svg)](https://gemnasium.com/mroth/lolcommits)
[![CodeClimate Status](https://d3s6mut3hikguw.cloudfront.net/github/mroth/lolcommits/badges/gpa.svg)](https://codeclimate.com/github/mroth/lolcommits)
[![Coverage Status](https://coveralls.io/repos/mroth/lolcommits/badge.svg?branch=master&service=github)](https://coveralls.io/r/mroth/lolcommits)


## Sample images

<img src="https://lolcommits.github.io/assets/img/gallery.jpeg" />

Please add your own lolcommit! Add to the [People Using
Lolcommits](https://github.com/mroth/lolcommits/wiki/Lolcommits-from-around-the-world%21)
page on our wiki.


## Requirements

* Ruby >= 2.0.0
* A webcam
* [ImageMagick](http://www.imagemagick.org)
* [ffmpeg](https://www.ffmpeg.org) (optional) for animated gif capturing


## Installation


### Mac OS X

You'll need ImageMagick installed. [Homebrew](http://mxcl.github.com/homebrew/)
makes this easy.

	brew install imagemagick

Then install with:

	[sudo] gem install lolcommits

If you're using RVM (or rbenv), you can/should probably omit the sudo, but the
default MacOSX Ruby install is dumb and requires it.

If [Boxen](https://boxen.github.com) is your thing, [try
this](https://github.com/AssuredLabor/puppet-lolcommits).

Lolcommits v0.8.1 was the last release to support Ruby < 2.0. If you'd like to
use this program on older rubies try:

    [sudo] gem install lolcommits --version 0.8.1   # for Ruby 1.9
    [sudo] gem install lolcommits --version 0.7.0   # for Ruby 1.8


### Linux

Install dependencies using your package manager of choice, for example in
Ubuntu:

    sudo apt-get install mplayer imagemagick libmagickwand-dev

For Ubuntu 14.04 or newer, you need to manually install ffmpeg since it no
longer ships with the default Ubuntu sources. [Downloads for
ffmpeg](http://ffmpeg.org/download.html)

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

From within any git repository, simply do a `lolcommits --enable`. From that
point on, any git commit will automatically trigger a lolcommit capture! All
lolcommits are stored in `~/.lolcommits` by default, placed in a subdirectory by
project name, and with a filename matching the commit hash.

You can also enable lolcommits across all your local git repos. Follow [these
steps](https://github.com/mroth/lolcommits/wiki/Enabling-Lolcommits-for-all-your-Git-Repositories)
to achieve this using `git init` and the `init.templatedir` setting.

Don't worry about it too much, half the fun of lolcommits is forgetting it's
installed!


### Other commands

Ok, if you insist... Since you know about `--enable`, common sense suggests
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
forked process. See the section below for more capture configuration variables.


### Capture configuration variables

lolcommits has some capture options for additional lulz. You can enable these
via environment variables like so;

* `LOLCOMMITS_DEVICE` set a webcam device - **mac and linux only**
* `LOLCOMMITS_ANIMATE` (in seconds) set time for capturing an animated gif -
  **requires ffmpeg**
* `LOLCOMMITS_DELAY` (in seconds) set delay persistently (for slow webcams to
  warmup)
* `LOLCOMMITS_FORK` fork lolcommit runner (capture command forks to a new
  process, speedily returning you to your terminal)
* `LOLCOMMITS_STEALTH` disable notification messages at commit time
* `LOLCOMMITS_DIR` set the output directory used for all repositories (defaults to ~/.lolcommits)
* `LOLCOMMITS_CAPTURE_DISABLED` short-cirtcuits the capture command if set to `1`

Or they can be set with these arguments to the capture command (located in your
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

To find out more, read about [loltext options](https://github.com/mroth/lolcommits/wiki/Configure-Commit-Capturing#loltext-options).


### Animated Gif Capturing

Animated gifs can take a while to generate (depending on the number of seconds
you capture and the capabilities of your machine).
[ffmpeg](https://www.ffmpeg.org) is required and can be installed like so;

* Linux - [follow this guide](https://www.ffmpeg.org/download.html#build-linux)
* OSX - `brew install ffmpeg`

To enable, just set the `LOLCOMMITS_ANIMATE` environment variable with the
number of seconds to capture. If you find animated capturing takes too long, try
setting `LOLCOMMITS_FORK=true`. Animated gif captures are currently NOT
supported on Windows.

![Example animated lolcommit
gif](http://cdn2.usa.bugleblogs.com/blogs/000/000/003/de0eb9aa695.gif "Example
animated lolcommit gif")


### Plugins

A growing number of plugins are available, allowing you to transform or share
your lolcommits with others. The default plugin simply appends your commit
message and sha to the captured image. Others can auto post to Twitter, Tumblr
(and other services), or even translate your commit messages to
[lolspeak](http://www.urbandictionary.com/define.php?term=lolspeak). They can be
easily enabled, configured or disabled with the `--config` option:

    lolcommits --config

Check them out on our [plugins
page](https://github.com/mroth/lolcommits/wiki/Configuring-Plugins).


## Timelapse

To watch your face as it decays while you program, you can create an animated
timelapse gif.

    lolcommits --timelapse
    # or for just today's lolcommits
    lolcommits --timelapse --period today

## Troubles?

Try our trouble-shooting [FAQ](https://github.com/mroth/lolcommits/wiki/FAQ), or
take a read through our [wiki](https://github.com/mroth/lolcommits/wiki) for
more information. If you think something is broken or missing, raise a [Github
issue](https://github.com/mroth/lolcommits/issues) (and please take a little
time to check if we haven't [already
addressed](https://github.com/mroth/lolcommits/issues?q=is%3Aissue+is%3Aclosed)
it).


## License

The program is available as open source under the terms of
[LGPL-3](https://opensource.org/licenses/LGPL-3.0).

