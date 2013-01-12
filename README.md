# lolcommits (git + webcam = lol)

Takes a snapshot with your Mac's built-in iSight/FaceTime webcam (or any working webcam on Linux or Windows) every time you git commit code, and archives a lolcat style image with it.

By default, the lolimages are stored by a Github style short SHA in a `~/.lolcommits` directory created for you.

[![Gem Version](https://badge.fury.io/rb/lolcommits.png)](http://badge.fury.io/rb/lolcommits)
[![Build Status](https://secure.travis-ci.org/mroth/lolcommits.png?branch=master)](http://travis-ci.org/mroth/lolcommits)
[![Dependency Status](https://gemnasium.com/mroth/lolcommits.png)](https://gemnasium.com/mroth/lolcommits)

## Installation (Mac OS X)
You'll need ImageMagick installed.  [Homebrew](http://mxcl.github.com/homebrew/) makes this easy.  Simply do:

	brew install imagemagick

Then simply do:

	[sudo] gem install lolcommits

(If you're using rvm or something like that, you can/should probably omit the sudo, but the default MacOSX Ruby install is dumb and requires it.)

You're all set!  To enable lolcommits for a git repo, go to the base directory of the repository, and run:

	lolcommits --enable

Likewise, you can disable it via `lolcommits --disable`.  For a full list of options, you can do `lolcommits --help`.

## Installation (Linux)
Install dependencies using your package manager of choice, for example in Ubuntu:

    sudo apt-get install mplayer imagemagick libmagickwand-dev

Then install the lolcommits gem:

    gem install lolcommits

Then you can `lolcommits --enable` in any git repo as above.

For more details, see [Installing on Linux](https://github.com/mroth/lolcommits/wiki/Installing-on-Linux).

## Installation (Windows)
See the wiki page for [Installing on Windows](https://github.com/mroth/lolcommits/wiki/Installing-on-Windows).

## Sample images
<img src="http://blog.mroth.info/images/postcontent/yearinsideprojects/lolcommits_users2.jpg" />

Please add your own lolcommit! Add to the [People Using Lolcommits](https://github.com/mroth/lolcommits/wiki/People-Using-Lolcommits) page on the Wiki.

## Options
lolcommits has some options for additional lulz.  You can enable via
environment variables.

 * Set webcam device on mac - set `LOLCOMMITS_DEVICE` environment variable.
 * Set delay persistently (for slow to warmup webcams) - set
   `LOLCOMMITS_DELAY` var to time in seconds.

## Plugins

 * TRANZLATE YOAR COMMIT_MSG TO LOLSPEKK - do 
   `lolcommits --config -p tranzlate` and set enabled to `true`.

## Troubles?
Started a [FAQ](https://github.com/mroth/lolcommits/wiki/FAQ).

## Timelapse?

To watch your face as it decays while you program, you can create a quick mpeg of all your lolcommits snapshots (if you have `imagemagick` and `ffmpeg` installed):

    convert `find . -type f -name "*.jpg" -print0 | xargs -0 ls -tlr | awk '{print $9}'` timelapse.mpeg
