# lolcommits

[![CI](https://img.shields.io/github/actions/workflow/status/lolcommits/lolcommits/ci.yml?branch=main&style=flat&label=CI)](https://github.com/lolcommits/lolcommits/actions/workflows/ci.yml)
[![Depfu](https://img.shields.io/depfu/lolcommits/lolcommits.svg?style=flat)](https://depfu.com/github/lolcommits/lolcommits)
[![Gem](https://img.shields.io/gem/v/lolcommits.svg?style=flat)](http://rubygems.org/gems/lolcommits)

> git-based selfies for software developers

[lolcommits](https://lolcommits.github.io/) takes a snapshot with your webcam
every time you git commit, archiving a
"[LOLcat](https://en.wikipedia.org/wiki/Lolcat)" style image. Git blame has
never been so much fun!

## Sample images

<img src="https://lolcommits.github.io/assets/img/gallery.jpeg" alt="Gallery
grid of captured lolcommit images" />

Feel free to add your own lolcommit to the [People Using
Lolcommits](https://github.com/lolcommits/lolcommits/wiki/Lolcommits-from-around-the-world%21)
page!


## Requirements

* Ruby >= 3.1
* A webcam
* [ImageMagick](http://www.imagemagick.org)
* [ffmpeg](https://www.ffmpeg.org) (optional) for animated gif capturing


## Installation

### macOS

You'll need ImageMagick installed. [Homebrew](https://brew.sh) makes this easy.

	brew install imagemagick

Then install with:

	gem install lolcommits

Optionally add ffmpeg if you plan on capturing animated gifs or videos.

	brew install ffmpeg

### Linux

Install dependencies using your package manager of choice. For example in
Ubuntu:

    sudo apt-get install mplayer imagemagick libmagickwand-dev

For Ubuntu 14.04 or newer, you'll need to manually install ffmpeg, as it no
longer ships with the base image ([download
here](http://ffmpeg.org/download.html)).

Then install with:

    gem install lolcommits

For more details, see [Installing on
Linux](https://github.com/lolcommits/lolcommits/wiki/Installing-on-Linux).

### Windows - here be dragons!

It works, but you'll need to follow some extra instructions to get dependencies
installed. See [Installing on
Windows](https://github.com/lolcommits/lolcommits/wiki/Installing-on-Windows).


## Usage

### Enabling and basic usage

Within any git repository, simply run

    lolcommits --enable

Now any git commit will automatically trigger a lolcommit capture! lolcommits
are stored in `~/.lolcommits` with a short sha filename and organized into
folders for each git repo.

Follow [these
steps](https://github.com/lolcommits/lolcommits/wiki/Enabling-Lolcommits-for-all-your-Git-Repositories)
to enable lolcommits across all your repos; using `git init` and the
`init.templatedir` setting.

Don't worry about it too much, half the fun of lolcommits is forgetting
it's even installed!


### Other commands

OK, if you insist... Since you know about `--enable`, common sense
suggests there is also a repository specific `--disable`, hopefully you
can guess what that does.

Other handy common commands include `--last`, which will open for
display your most recent lolcommit, or `--browse`, which pops open the
directory containing all the lolcommit images for your current
repository.

Use `--help` for a full list of available commands.

**TIP**: Any extra args you pass with `--enable` are auto-appended to
the git hook capture command. For example;

    lolcommits --enable --delay 2 --animate 4 --fork

Configures capturing of an animated gif (4 secs) after a 2 sec delay in a forked
process.


### Capture configuration options

lolcommits has some capture options for additional lulz. You can enable
these via environment variables like so;

* `LOLCOMMITS_DEVICE` set a webcam device - **except windows
  (non-animated) captures**
* `LOLCOMMITS_VIDEO` (in seconds) set time for capturing a video -
  **requires ffmpeg**
* `LOLCOMMITS_ANIMATE` (in seconds) set time for capturing an animated
  gif - **requires ffmpeg**
* `LOLCOMMITS_DELAY` (in seconds) set delay time before capturing (for
  slow webcams to warmup)
* `LOLCOMMITS_FORK` fork lolcommit runner (capture command forks to a
  new process, speedily returning you to your terminal)
* `LOLCOMMITS_STEALTH` disable all notification messages when capturing
* `LOLCOMMITS_DIR` set the output directory used for all repositories
  (defaults to ~/.lolcommits)
* `LOLCOMMITS_CAPTURE_DISABLED` disables lolcommit capturing in the
  commit hook (when set as 'true')

Or apply arguments directly on the git hook capture command (located in
your repository's `.git/hooks/post-commit` file).

* `--device {name}` or `-d {name}`
* `--video {seconds}` or `-v {seconds}`
* `--animate {seconds}` or `-a {seconds}`
* `--delay {seconds}` or `-w {seconds}`
* `--fork`
* `--stealth`

You can configure lolcommit text layout, font styles (type, size, color etc.) or
add a transparent overlay to your images. Simply configure the default loltext
plugin with this command:

    lolcommits --config -p loltext

To find out more about styling, read about the [loltext
options](https://github.com/lolcommits/lolcommits/wiki/Configure-Commit-Capturing#loltext-options).

Use `lolcommits --devices` to list all attached video devices available for
capturing.

Finally, `lolcommits --help` has details on all available arguments.


### Videos

You can tell lolcommits to capture an mp4 video (instead of an image).
[ffmpeg](https://www.ffmpeg.org) is required and can be installed like
so;

* macOS - `brew install ffmpeg`
* Linux - [follow this
  guide](https://www.ffmpeg.org/download.html#build-linux)
* Windows - [follow this
  guide](https://ffmpeg.org/download.html#build-windows)

To enable, use the `-v {seconds}` option or set the `LOLCOMMITS_VIDEO`
environment variable with the number of seconds to capture.


### Animated Gifs

Animated gifs can take a while to generate (depending on the number of
seconds you capture and the capabilities of your machine).

To enable, use the `-a {seconds}` option or set the `LOLCOMMITS_ANIMATE`
environment variable with the number of seconds to capture. If you find
animated capturing takes too long, try setting `LOLCOMMITS_FORK=true`.

![Example animated lolcommit
gif](http://cdn2.usa.bugleblogs.com/blogs/000/000/003/de0eb9aa695.gif
"Example animated lolcommit gif")

**NOTE**: If both `LOLCOMMITS_ANIMATE` and `LOLCOMMITS_VIDEO` options are set,
the video duration takes precedence and is applied to both captures.


### Plugins

A growing number of plugins are available, allowing you to transform or share
your lolcommits with others.

The default `loltxt` plugin simply appends your commit message and sha to the
captured image. Others can post to Twitter, Tumblr or HTTP Post anywhere. You
can even translate your commit messages to
[lolspeak](http://www.urbandictionary.com/define.php?term=lolspeak).

Check them out on our [plugins
page](https://github.com/lolcommits/lolcommits/wiki/Configuring-Plugins).

To list all installed plugins use:

    lolcommits --plugins

Installed plugins can be easily enabled, configured or disabled with the
`--config` option:

    lolcommits --config
    # or
    lolcommits --config -p loltext

Interested in developing your own? Follow [this plugin developers
guide](https://github.com/lolcommits/lolcommits-sample_plugin#developing-your-own-plugin).


## Timelapse

Watch your face rapidly decay while you program! Enjoy (or despair) with:

    lolcommits --timelapse
    # or for just today's lolcommits
    lolcommits --timelapse --period today

## Development

Check out this repo and run `bundle install` to install dependencies.

### Tests

Cucumber is used for testing. Run the full suite with:

    $ cucumber

Some MiniTest unit tests can also be ran with:

    $ rake test

### Linting

[Rubocop](https://github.com/rubocop/rubocop) is used for linting, and a git
[quickhook](https://github.com/dirk/quickhook) can be installed to check this on
a pre-commit.

    $ rubocop

    $ quickhook install

### Docs

Generate docs for this gem with:

    $ rake rdoc

## Troubles?

Try our trouble-shooting
[FAQ](https://github.com/lolcommits/lolcommits/wiki/FAQ), or take a read through
our [wiki](https://github.com/lolcommits/lolcommits/wiki).

If you think something is broken or missing, please raise a [Github
issue](https://github.com/lolcommits/lolcommits/issues).

## History

Originally created by [@mroth] in 2011 (as a joke project for [Hack && Tell]),
lolcommits has grown considerably, has a plugin ecosystem and is now maintained
by [@matthutchinson].

Thanks to all the [contributors] and users throughout the years!

[@matthutchinson]: https://github.com/matthutchinson
[@mroth]: https://github.com/mroth
[Hack && Tell]: https://hackandtell.org
[contributors]: https://github.com/lolcommits/lolcommits/graphs/contributors

## License

The program is available as open source under the terms of
[LGPL-3](https://opensource.org/licenses/LGPL-3.0).
