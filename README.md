![lion](http://9.mshcdn.com/follow/uploads/topic/image/67/3d/84/a9/e6/29/thumb_mountain-lion-eb890e1974.png) **HAVING TROUBLE AFTER UPGRADING TO MOUNTAIN LION? [READ THIS.](https://github.com/mroth/lolcommits/issues/65)**

# lolcommits (git + webcam = lol)

Takes a snapshot with your Mac's built-in iSight/FaceTime webcam (or any working webcam on Linux) every time you git commit code, and archives a lolcat style image with it.

By default, the lolimages are stored by a Github style short SHA in a `~/.lolcommits` directory created for you.

[![Build Status](https://secure.travis-ci.org/mroth/lolcommits.png?branch=master)](http://travis-ci.org/mroth/lolcommits)
[![Dependency Status](https://gemnasium.com/mroth/lolcommits.png)](https://gemnasium.com/mroth/lolcommits)

## Installation (Mac OS X)
You'll need ImageMagick installed.  [Homebrew](http://mxcl.github.com/homebrew/) makes this easy.  Simply do:

	brew install --build-from-source imagemagick

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
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/assets/img/sample_old/sample2.jpg" />
&nbsp;
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/assets/img/sample_old/sample5.jpg" />
<br/>
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/assets/img/sample_old/sample4.jpg" />
&nbsp;
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/assets/img/sample_old/sample6.jpg" />
<br/>
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/assets/img/sample_old/sample7.jpg" />
&nbsp;
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/assets/img/sample_old/sample8.jpg" />
<br/>
<a href="http://github.com/sfsekaran/"><img width='320' height='240' src="http://cl.ly/252S0o1J3x3n1b1k251N/d5f80e4f88a.jpg" /></a>
&nbsp;
<a href="http://github.com/codegoblin/"><img width='320' height='240' src="http://cl.ly/2R0u040D2E2k0Y03240B/19bda811539.jpg" /></a>
<br/>
<img width='320' height='240' src="https://p.twimg.com/AqE73M1CMAAerqL.jpg" />
&nbsp;
<img width='320' height='240' src="https://p.twimg.com/Aq9T0X9CAAAZ8gW.jpg" />

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please, if at all possible, write a passing test for the functionality you added.

## Troubles?
Started a [FAQ](https://github.com/mroth/lolcommits/wiki/FAQ).
