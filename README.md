[![Build Status](https://secure.travis-ci.org/mroth/lolcommits.png?branch=master)](http://travis-ci.org/mroth/lolcommits)

# git + webcam = lol

Takes a snapshot with your Mac's built-in iSight/FaceTime webcam (or any working webcam on Linux) every time you git commit code, and archives a lolcat style image with it.

By default, the lolimages are stored by a Github style short SHA in a `~/.lolcommits` directory created for you.

## Installation (Mac OS X)
You'll need ImageMagick installed.  [Homebrew](http://mxcl.github.com/homebrew/) makes this easy.  Simply do:

	brew install imagemagick --from-source

Then simply do:

	[sudo] gem install lolcommits

(If you're using rvm or something like that, you can/should probably omit the sudo, but the default MacOSX Ruby install is dumb and requires it.)

You're all set!  To enable lolcommits for a git repo, go to the base directory of the repository, and run:

	lolcommits --enable

Likewise, you can disable it via `lolcommits --disable`.  For a full list of options, you can do `lolcommits --help`.

## Installation (Linux)
Install dependencies using your package manager of choice, for example in Ubuntu:

    sudo apt-get install mplayer imagemagick libmagickwand-dev

On Fedora, enable the rpmfusion repository (for mplayer) and run:

    sudo yum install ImageMagick ImageMagick-devel mplayer

Then install the lolcommits gem:

    gem install lolcommits

Then you can `lolcommits --enable` in any git repo as above.

## Installation (Windows)
See the wiki page for [Installing on Windows](https://github.com/mroth/lolcommits/wiki/Installing-on-Windows).

## Sample images
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample2.jpg" />
&nbsp;
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample5.jpg" />
<br/>
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample4.jpg" />
&nbsp;
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample6.jpg" />
<br/>
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample7.jpg" />
&nbsp;
<img width='320' height='240' src="https://github.com/mroth/lolcommits/raw/gh-pages/sample8.jpg" />
<br/>
<a href="http://github.com/sfsekaran/"><img width='320' height='240' src="http://cl.ly/252S0o1J3x3n1b1k251N/d5f80e4f88a.jpg" /></a>
&nbsp;
<a href="http://github.com/codegoblin/"><img width='320' height='240' src="http://cl.ly/2R0u040D2E2k0Y03240B/19bda811539.jpg" /></a>
<br/>
<img width='320' height='240' src="https://p.twimg.com/AqE73M1CMAAerqL.jpg" />
&nbsp;
<img width='320' height='240' src="https://p.twimg.com/Aq9T0X9CAAAZ8gW.jpg" />

Please add your own lolcommit! Add to the [People Using Lolcommits](https://github.com/mroth/lolcommits/wiki/People-Using-Lolcommits) page on the Wiki.

## Troubles?
Started a [FAQ](https://github.com/mroth/lolcommits/wiki/FAQ).

<!--
## Upgrading from an old (non-gem) version?
If you used the autoinstaller, here's how to get rid of the old stuff (I think)

For all active lolrepos, go into them and do:

	git hooks --uninstall

You might want to get rid of the copied binary for imagesnap and switch over to the homebrew-managed version, if so `rm /usr/local/bin/imagesnap`.

If you want to get rid of git-hooks entirly (it won't hurt anything, but we dont use it anymore), you can also do:

	rm /usr/local/bin/git-hooks
	rm -rf ~/.git_hooks
	rm -rf ~/.githooks_src
-->
