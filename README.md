# lolcommits (git + webcam = lol)

lolcommits takes a snapshot with your webcam every time you git commit code, and archives a lolcat style image with it.
Git blame has never been so much fun.

By default, the lolimages are stored by a Github style short SHA in a `~/.lolcommits` directory created for you.

[![Gem Version](https://badge.fury.io/rb/lolcommits.png)](http://badge.fury.io/rb/lolcommits)
[![Build Status](https://secure.travis-ci.org/mroth/lolcommits.png?branch=master)](http://travis-ci.org/mroth/lolcommits)
[![Dependency Status](https://gemnasium.com/mroth/lolcommits.png)](https://gemnasium.com/mroth/lolcommits)

## Sample images
<img src="http://blog.mroth.info/images/postcontent/yearinsideprojects/lolcommits_users2.jpg" />

Please add your own lolcommit! Add to the [People Using Lolcommits](https://github.com/mroth/lolcommits/wiki/People-Using-Lolcommits) page on the Wiki.

## Installation
### Mac OS X
You'll need ImageMagick installed.  [Homebrew](http://mxcl.github.com/homebrew/) makes this easy.  Simply do:

	brew install imagemagick

Then simply do:

	[sudo] gem install lolcommits

(If you're using RVM, you can/should probably omit the sudo, but the default MacOSX Ruby install is dumb and requires it.)

### Linux
Install dependencies using your package manager of choice, for example in Ubuntu:

    sudo apt-get install mplayer imagemagick libmagickwand-dev

Then install the lolcommits gem:

    gem install lolcommits

For more details, see [Installing on Linux](https://github.com/mroth/lolcommits/wiki/Installing-on-Linux).

### Windows
Here be dragons! It all works but you'll need some more detailed instructions to get the dependencies installed.  See the wiki page for [Installing on Windows](https://github.com/mroth/lolcommits/wiki/Installing-on-Windows).

## Usage
### Enabling and basic usage
From within any git repository, simply do a `lolcommits --enable`. From that point on, any git commit will automatically trigger a lolcommit capture! All lolcommits are stored in `~/.lolcommits` by default, placed in a subdirectory by project name, and with a filename matching the commit hash.

Don't worry about it too much, half the fun of lolcommits is forgetting it's installed!

### Other commands
Ok, if you insist... Since you know about `--enable`, common sense suggest there is also a repository specific `--disable`, hopefully you can guess what that does. Other handy common commands include `--last`, which will open for display your most recent lolcommit image, or `--browse`, which pops open the directory containing all the lolcommit images for your current repository. You can always do `--help` for a full list of available commands.

### Configuration variables
lolcommits has some options for additional lulz.  You can enable via
environment variables.

 * Set webcam device on mac - set `LOLCOMMITS_DEVICE` environment variable.
 * Set delay persistently (for slow to warmup webcams) - set
   `LOLCOMMITS_DELAY` var to time in seconds.
 * Set font file location - set `LOLCOMMITS_FONT` environment variable.
 * Animated gifs - set `LOLCOMMITS_ANIMATE=3` (currently Mac/OSX only and requires `ffmpeg`).
 * Fork lolcommits runner - set `LOLCOMMITS_FORK` environment variable
   (causes capturing command to fork to a new process, speedily returning you to your terminal).

For the full list, see the [configuration variables](https://github.com/mroth/lolcommits/wiki/Configuration-Variables).

### Animated Gif Capturing

Animated gifs (Mac/OSX only) can take a while to generate (depending on the number of seconds you capture and the capabilities of your machine). `ffmpeg` is required and can be installed with brew like so;

    brew install ffmpeg

Use the `LOLCOMMITS_ANIMATE` environment variable with the number of seconds to capture. [Wacaw](http://webcam-tools.sourceforge.net) is used to capture the video. The `LOLCOMMITS_DEVICE` env variable can be used to change wacaw's `video-device` argument.

<img src="http://cdn2.usa.bugleblogs.com/blogs/000/000/003/de0eb9aa695.gif" />

### Plugins

There are a growing amount of plugins for lolcommits to enable things like Twitter upload, translating your commit messages to lolspeak, etc.  Check them out on the [plugins wiki page](https://github.com/mroth/lolcommits/wiki/Plugins).

## Troubles?
Started a [FAQ](https://github.com/mroth/lolcommits/wiki/FAQ).

## Timelapse?

To watch your face as it decays while you program, you can create a quick mpeg of all your lolcommits snapshots (if you have `imagemagick` and `ffmpeg` installed):

    convert `find . -type f -name "*.jpg" -print0 | xargs -0 ls -tlr | awk '{print $9}'` timelapse.mpeg
