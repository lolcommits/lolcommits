### ChangeLog

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning][Semver].

## [Unreleased]

  * Your contribution here!

## [0.16.2][] (24 Aug 2020)
  * Support delays w/ Linux animated GIFs (@theY4Kman [#405][])
  * Upgrade git gem to version 1.6.0 (@depfu [#402][])
  * Upgrade lolcommits-loltext to version 0.4.0 (@depfu [#401][])

## [0.16.1][] (21 Jan 2020)
  * Upgrade mini_magick to version 4.10.1 (@depfu [#399][])
  * Fix rubocop config (@Salzig [#400][])

## [0.16.0][] (21 Oct 2019)
  * update macOS binaries for Catalina support (@matthutchinson, @samwize [#398][])

## [0.15.1][] (6 Jun 2019)
  * fix device list command (@matthutchinson [#394][])

## [0.15.0][] (20 May 2019)
  * require at least lolcommits-loltext `>= 0.3.0` (@matthutchinson)
  * remove `main_image` method, plugins should use `lolcommit_path` on
    `runner` object (@matthutchinson)

## [0.14.2][] (19 May 2019)
  * minor runner improvements, `capture_image?` now public
    (@matthutchinson)

## [0.14.1][] (14 May 2019)
  * minor runner improvements, for friendly plugin testing
    (@matthutchinson)

## [0.14.0][] (14 May 2019)
  * `main_image` now deprecated, use `lolcommit_path` instead (@matthutchinson)
  * make actual videos to make gifs from (@ruxton [#386][])
  * improved tabs/spacing on git commit hook text (@matthutchinson)
  * add video captures `-v {seconds}` and runner overlays (@matthutchinson [#392][])
  * `Capturer` classes refactored and renamed (@matthutchinson)
  * `AnimatedGif` class takes care of gif generating (@matthutchinson)

## [0.13.1][] (29 April 2019)
  * Update all links and badges (in gemspec, README etc.) to lolcommits
    organisation (@matthutchinson)
  * remove gem `post_install` message (@matthutchinson)
  * use `lolcommits-loltext ~> 0.1.0` (@matthutchinson)

## [0.13.0][] (23 April 2019)
  * Require at least Ruby 2.3
  * Upgrade git gem dependency to 1.5.0 (@matthutchinson [#377][])
  * Upgrade mini_magick gem dependency to 4.9.3 (@matthutchinson [#385][])
  * Add History and Contributor section to README (@mroth [#385][])
  * add frozen_string_literal: true comment to all Ruby files
  * change $PATH override precedence in hooks installers
  * Updated COC (Contributor Covenant v1.4)
  * Added PR template

## [0.12.1][] (27 March 2018)
  * Name passed to `Plugin::Base` initializer (@matthutchinson)
  * Removed dead method `configured?` in `Plugin::Base`
  * Using `YAML.safe_load` for configuration loading

## [0.12.0][] (15 March 2018)
  * Use CodeClimate and simplecov for coverage reports (@matthutchinson [#367][])
  * Remove plugin runner order (@matthutchinson [#369][])

## [0.11.0][] (4 February 2018)
  * Require at least Ruby 2.1 (@matthutchinson [#366][])
    - drop support for Ruby 2.0
    - update all remaining gem dependencies (incl. Aruba, Cucumber)
    - remove @unstable tag from features

## [0.10.0][] (10 January 2018)
  * Plugin configuration changes (@matthutchinson [#365][])
    - `--plugins` now shows if plugin is enabled or not
    - `default_options` now available, nested hash with default values
    - if `valid_configuration?` fails, warning message shows
    - `prompt_autocomplete_hash` helper method added
  * Better plugin config flow (@matthutchinson [#363][])

## [0.9.8][] (3 December 2017)
  * Extract protonet to gem (@matthutchinson [#361][])
  * Extract flowdock to gem (@matthutchinson [#360][])
  * Extract yammer to gem (@matthutchinson [#359][])
  * Extract hipchat to gem (@matthutchinson [#358][])
  * Extract tumblr to gem (@matthutchinson [#357][])
  * Extract term_output to gem (@matthutchinson [#356][])
  * Add Ruby 2.4.2 to Travis config (@matthutchinson)

## [0.9.7][] (17 September 2017)
  * Extract dotcom to gem (@matthutchinson [#355][])
  * Extract uploldz to gem (@matthutchinson [#354][])
  * Extract lolsrv to gem (@matthutchinson [#353][])

## [0.9.6][] (28 August 2017)
  * Clean legacy plugin methods (@matthutchinson [#348][])
  * Extract Slack Plugin to gem (@matthutchinson [#349][])
  * Fix Windows install hook (@matthutchinson)
  * Animated capturing for Windows via ffmpeg (@freehugs [#351][])
  * Pin `public_suffix` gem version (@matthutchinson [#352][])

## [0.9.5][] (21 July 2017)
  * Extract Twitter Plugin / refactor Plugin::Base (@matthutchinson [#347][])

## [0.9.4][] (17 April 2017)
  * Add captureready plugin hook (@matthutchinson [#342][])
  * README changes (@mroth [#341][])
  * Extract tranzlate plugin to gem (@matthutchinson [#340][])
  * Extract loltext plugin to gem (@matthutchinson [#339][])

## [0.9.3][] (5 April 2017)
  * LOLCOMMITS_CAPTURE_DISABLED env var (@williamboman [#338][])
  * Plugin Manager and Gem plugin support (@matthutchinson [#332][])
  * Add North gravity for ImageMagick (@domudall [#331][])
  * remove Ruby 1.9 magic comments (@matthutchinson [#330][])
  * add links to PRs in CHANGELOG (@bfontaine [#329][])

## [0.9.2][] (3 January 2017)
  * Remove twitter gem, fixes Ruby 2.4 issues (@matthutchinson [#328][])

## [0.9.1][] (20 December 2016)
  * Remove Choice gem, use Methadone (@matthutchinson [#326][])

## [0.9.0][] (14 December 2016)
  * ditch ruby 1.9 support and upgrade some gems (@matthutchinson [#325][])
  * term_output plugin added (iTerm2 only) (@ruxton [#323][])

## [0.8.1][] (11 October 2016)
  * **last release supporting Ruby < 2.0**
  * shebang fix in installer (@matthutchinson [#317][])
  * FlowDock plugin (@mikecrittenden [#318][])
  * HipChat plugin (@Salzig [#320][])
  * peg gems for legacy ruby 1.9.3 (@matthutchinson [#321][])

## [0.8.0][] (13 July 2016)
  * New release requires Ruby 1.9.3+ minimum (@matthutchinson [#313][])
  * All gems upgraded to latest versions (6 held back, see lolcommits.gemspec)
  * See [this issue](https://github.com/lolcommits/lolcommits/issues/310) for details

## [0.7.0][] (13 July 2016)
  * **last release supporting Ruby < 1.9.3** (@matthutchinson [#313][])

## [0.6.7][] (8 June 2016)
  * Remove `console` binary from packaged gem (@samgranieri [#309][])

## [0.6.6][] (1 June 2016)
  * Show error/exit when --config outside a git repo (@matthutchinson [#308][])
  * Add more options to loltext plugin (@ruxton [#304][])
  * Added CODE_OF_CONDUCT.md to repo (@matthutchinson)
  * Added a useful `console` binary for development and debugging (@matthutchinson)

## [0.6.5][] (12 April 2016)
  * Add mercurial support (@tak [#301][] [#302][] [#303][])

## [0.6.4][] (15 March 2016)
  * Add quotes to correctly handle paths with spaces (@matthutchinson [#298][])

## [0.6.3][] (14 March 2016)
  * Add quotes to correctly handle paths with spaces (@pedrocunha [#296][])
  * Added plugin config path to output (@KrauseFx [#294][])

## [0.6.2][] (21 February 2016)
  * Avoid invoking ruby if in a rebase (@jhawthorn [#286][])
  * Slow gif problem on mac (@a06kin [#289][])
  * Peg RuboCop gem to 0.37.2 and fix cop issues (@matthutchinson [#292][])

## [0.6.1][] (16 September 2015)
  * Optional http auth header user/password in uploldz plugin (@felixroos [#283][])
  * Slack plugin added (@yasakbulut [#284][])
  * Updated rubies in Travis settings (@matthutchinson)
  * Fixed README badge URLS (@matthutchinson)

## [0.6.0][] (27 July 2015)
  * Configurable text options for loltext plugin (@matthutchinson [#282][])
  * Working AppVeyor configuration added (@nysthee [#280][])
  * Tumblr plugin (@mveytsman [#279][])
  * CHANGELOG (this file) now in markdown format (@matthutchinson)

## [0.5.9][] (24 April 2015)
  * Fix windows post commit hook path (@matthutchinson [#278][])

## [0.5.8][] (22 April 2015)
  * Fix Windows MiniMagick issue (@matthutchinson [#276][])
  * Rubocop code clean ups (@nysthee [#272][])
  * Fix gem issues on earlier Ruby versions ([#270][])
  * CLI refactoring/cleanups (@mroth [#254][] [#258][] [#266][] [#267][] [#266][])
  * Exit with -1 for bad CLI args (@williamboman [#263][])
  * Move unit tests to MiniTest (@mroth [#256][])
  * Add branch name to git info (@salzig [#252][])
  * lol_protonet plugin added (@salzig [#251][])
  * Allow local plugins in $LOLCOMMITS_DIR/.plugins (@salzig [#250][])

## [0.5.7][] (28 December 2014)
  * Uploldz plugin sends more post params (@clops [#224][] @matthutchinson [#241][])
  * More configurable twitter plugin (@woodrowbarlow [#207][] @matthutchinson)
  * Upgrade all gems that can be, 4 held back ([#244][] @matthutchinson)
  * Ruby 2.2.0 compatible ([#244][] @matthutchinson)
  * Glob /dev/video for default video device (linux only) ([#246][] @Ferada)

## [0.5.6][] (24 November 2014)
  * Updates and clean ups on the gemspec (@mroth [#228][])
  * Travis CI now includes ruby-head (@mroth [#229][])
  * Improved error message for ImageMagick issues [#159][] (@matthutchinson [#233][])
  * Fix twitter plugin config issue [#231][] (@matthutchinson [#232][])
  * Update mini_magick gem to 3.8.1 (@matthutchinson [#234][])
  * Improve README for LOLCOMMITS_DIR (@dagar [#235][])
  * Update README to include ffmpeg installation (@VictorBjelkholm [#236][])
  * Better failover when no snapshot created  (@matthutchinson [#237][])
  * Export LANG to post-commit hook, fixes GitHub client (@matthutchinson [#240][])

## [0.5.5][] (29 September 2014)
  * Animated gif capture support (@theY4Kman [#226][])
  * Fix plugin config issues with user input (@matthutchinson [#225][] [#223][])
  * Fix Linux FPS timing issues (@matthutchinson [#215][])
  * Fix hook enable/disable issue (@matthutchinson [#206][])
  * Fix Git GUI issues (@matthutchinson [#196][] [#168][] [#193][] [#188][] [#159][] [#133][] [#123][] [#119][] [#104][] [#83][])
  * Mention Boxen script in README (@matthutchinson [#208][])
  * Explain global Git hooks how-to in README (@matthutchinson [#212][] [#112][])
  * Minor improvments to Linux Capturer (@matthutchinson)

## [0.5.4][] (13 April 2014)
  * Excluded vendor/bundle from rubocop cops (@matthutchinson)
  * Peg fivemat gem to ~> 1.2.1 (@mroth)
  * Fix lolsrv log file issue (@matthutchinson [#202][])
  * Yammer Plugin added (@mrclmvn [#160][])
  * Refactor on capture options (@mroth)

## [0.5.3][] (30 March 2014)
  * Fixed permissions on CommandCam (755) for cygwin (@matthutchinson)
  * Added `--devices` option, mac only for now (@matthutchinson [#183][], [#174][])
  * Replace http with https in twitter plugin (@kleinschmidt [#195][])
  * RuboCop gem added for development (@mroth [#194][])
  * Added optional key to uploldz plugin (@Numan1617 [#192][])
  * Fixed lolcommmits typo: too much mmm (@penyaskito [#189][])
  * Work when in subdirectory of a git repo (@ilkka [#186][])
  * Added --version (-v) flag (@bfontaine [#184][])
  * Send more VCS details to lolsrv (@drewwells [#181][])

## [0.5.2][] (5 December 2013)
  * Allow lolsrv plugin to sync/upload gifs (@matthutchinson [#180][])
  * Plugins refactor, can now configure themselves (@matthutchinson [#179][])
    - also closes issue [#136][] and issue [#73][]
  * Fix for Twitter gem dependency issue (@matthutchinson [#178][])
  * Added coveralls support (@Aaron1011 [#177][])
    - gitignore updated, coveralls badge added to README
  * Refactor tranzlate plugin, lolspeak now in plugin (@matthutchinson [#176][])
  * Fix for 'Cannot satisfy json dependancy' (@matthutchinson [#175][])
  * Better post commit hook enabling/disabling (@matthutchinson [#173][])
  * Improved --enable option, accepts passing arguments (@matthutchinson [#154][])
    - README updated to explain enabling with options

## [0.5.1][] (13 November 2013)
  * Fix JSON gem issue [#163][] (@matthutchinson, [#171][])
  * Enable image capture under Cygwin (@cwc, [#105][])
  * Add Ruby PATH to post-commit hook (@matthutchinson, [#155][])
  * "Stealth mode" where no notification is given (@sionide21, [#156][])
  * BUGFIX: comparison error for animate (@Yabes, [#151][])

## [0.5.0][] (10 September 2013)
  * better handling of LOLCOMMITS_DELAY (thx @leewillis77, [#125][])
  * LOLCOMMITS_DEVICE support on Linux (thx @EbenezerEdelman, [#139][])
  * better handling of repository names (thx @drocamor and @andromedado, [#145][] and [#146][])
  * added new LOLCOMMITS_ANIMATE (or `--animate`) option (Mac/OSX only) ([#114][], [#108][])
    - defaults to a 320x240 sized animated gif
    - new vendored binary videosnap - https://github.com/matthutchinson/videosnap
    - feature requires ffmpeg
    - README updated with details and an example

## 0.4.6 (12 August 2013)
  * Fix for incorrect permissioning in gem issue (see [#112][])

## 0.4.5 (8 July 2013)
  * disable&remove statsd plugin (as per [#94][])
  * fix issues with animated gif generation ([#107][])
  * added new LOLCOMMITS_FORK (or --fork) option to fork the runner capturing ([#109][])

## 0.4.4 (28 June 2013)
  * add -g option to produce animated gifs! (thx @hSATAC, [#95][])

## 0.4.3 (29 March 2013)
  * bump mini_magick dependency to deal with security alert

## 0.4.2 (11 March 2013)
  * fix ruby 2.0 compatibility ([#91][])
  * gracefully detect upstream issue with git color.ui being set to always ([#50][])
  * handle external capture devices with special characters in name ([#93][])
  * fixes to the uploldz plugin ([#92][])

## 0.4.1 (17 February 2013)
  * add lolsrv plugin (thx @sebastianmarr!, [#82][])
  * enable feature to change font (thx @fukayatsu!, [#89][])
  * correct activesupport gem name in bundle (thx @djbender!, [#90][])
  * graceful detection of imagemagick not being installed ([#87][])
  * restructure logging slightly to use Methadone::CLILogging in most places
  * add a bunch of debugging output, viewable via --debug flag

## 0.4.0 (13 January 2013)
  * Switch the main ImageMagick wrapper from RMagick to mini_magick
    - fix for RMagick not working with ImageMagick 6.8+ and generally
      being a buggy unmaintained piece of crap
    - this should also result in less problems with IM version changes
    - some preliminary test work on using image_sorcery instead too
    - perhaps finally kill issue [#9][] from continually resurfacing
  * make sure quotes are properly handled in commit messages
  * silence warnings generated by twitter gem in MRI 1.8.7

## 0.3.4 (27 December 2012)
  * Add uploldz plugin for posting to a remote server (thx @cnvandev)

## 0.3.3 (26 November 2012)
  * BUG: prevent repeated firing of lolcommits capture during a git rebase.

## 0.3.2 (3 October 2012)
  * Twitter posting support via the `twitter` plugin! (thx @coyboyrushforth!)

## 0.3.1 (5 August 2012)
  * fix regression with linux capture introduced in previous version

## 0.3.0 (3 August 2012)
  * fix bug involving git repositories with spaces in the name
  * internal refactoring for modularity (thanks @kenmazaika!), should be easier
    to add new plugin features to lolcommits now.
  * add some extremely basic anonymous usage tracking (if this bugs you, you
    can disable via disabling the `statsd` plugin).

## 0.2.0 (6 July 2012)
  * improved build system and testing with cucumber/methadone
    - goal is to get into a better framework to start doing major feature work
    - this should lead to increased reliability across systems as we refactor
  * writing tests (please help!)
  * fix issues with packaged files not being readable after a sudo gem install

## 0.1.5 (25 June 2012)
  * fix tranzlate on ruby1.8

## 0.1.4 (28 May 2012)
  * set device on mac via --device (or LOLCOMMITS_DEVICE env variable) --
    thanks @pioz (pull [#51][])

## 0.1.3 (18 May 2012)
  * add LGPLv3 license
  * add option to translate your commit message to lolspeak! (thx
    to @DanielleSucher!). To enable, set `LOLCOMMITS_TRANZLATE=1`.
  * fix issue with older versions of IM crashing on interline spacing (pull [#31][] via @german)
  * fix issue with git repos with no hooks directory (pull [#43][] via @mkmaster)
  * fix missing dash in capture -c

## 0.1.2 (22 April 2012)
  * provide licensing info for CommandCam (Windows)
  * bundle imagesnap as well to remove a dependency on Mac OS X

## 0.1.1 (21 April 2012)
  * Windows compatibility! Thanks to @Prydonious.

## 0.1.0 (19 April 2012)
  * Linux compatibility! Thanks to @madjar, @cscorely, and @Prydonius.

## 0.0.3 (16 April 2012)
  * use only first line for multi-line commit msgs (pull req [#21][])
  * clean up some command line options

## 0.0.2 (2 April 2012)
  * add --delay option to delay image capture (thx JohanB), can be
  persistently set via LOLCOMMITS_DELAY environment variable.
  * add --last command to view most recent lolcommit for a repo
  * add --browse command to open the lolcommit images directory for a particular repo

## 0.0.1 (29 March 2012)
  * initial release as a gem package, major refactoring for this
  * refactored to remove git-hooks package dependency, now installs stub hook
  directly into each git repo
  * wordwrap commit_msg manually, to switch to use imagemagick annotate
  instead of compositing multiply image Caption objects (this seems to be more
  reliable to not glitch.)

[Semver]: http://semver.org
[Unreleased]: https://github.com/lolcommits/lolcommits/compare/v0.16.2...HEAD
[0.16.2]: https://github.com/lolcommits/lolcommits/compare/v0.16.1...v0.16.2
[0.16.1]: https://github.com/lolcommits/lolcommits/compare/v0.16.0...v0.16.1
[0.16.0]: https://github.com/lolcommits/lolcommits/compare/v0.15.1...v0.16.0
[0.15.1]: https://github.com/lolcommits/lolcommits/compare/v0.15.0...v0.15.1
[0.15.0]: https://github.com/lolcommits/lolcommits/compare/v0.14.1...v0.15.0
[0.14.2]: https://github.com/lolcommits/lolcommits/compare/v0.14.1...v0.14.2
[0.14.1]: https://github.com/lolcommits/lolcommits/compare/v0.14.0...v0.14.1
[0.14.0]: https://github.com/lolcommits/lolcommits/compare/v0.13.1...v0.14.0
[0.13.1]: https://github.com/lolcommits/lolcommits/compare/v0.13.0...v0.13.1
[0.13.0]: https://github.com/lolcommits/lolcommits/compare/v0.12.1...v0.13.0
[0.12.1]: https://github.com/lolcommits/lolcommits/compare/v0.12.0...v0.12.1
[0.12.0]: https://github.com/lolcommits/lolcommits/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/lolcommits/lolcommits/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/lolcommits/lolcommits/compare/v0.9.8...v0.10.0
[0.9.8]: https://github.com/lolcommits/lolcommits/compare/v0.9.7...v0.9.8
[0.9.7]: https://github.com/lolcommits/lolcommits/compare/v0.9.6...v0.9.7
[0.9.6]: https://github.com/lolcommits/lolcommits/compare/v0.9.5...v0.9.6
[0.9.5]: https://github.com/lolcommits/lolcommits/compare/v0.9.4...v0.9.5
[0.9.4]: https://github.com/lolcommits/lolcommits/compare/v0.9.3...v0.9.4
[0.9.3]: https://github.com/lolcommits/lolcommits/compare/v0.9.2...v0.9.3
[0.9.2]: https://github.com/lolcommits/lolcommits/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/lolcommits/lolcommits/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/lolcommits/lolcommits/compare/v0.8.1...v0.9.0
[0.8.1]: https://github.com/lolcommits/lolcommits/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/lolcommits/lolcommits/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/lolcommits/lolcommits/compare/v0.6.7...v0.7.0
[0.6.7]: https://github.com/lolcommits/lolcommits/compare/v0.6.6...v0.6.7
[0.6.6]: https://github.com/lolcommits/lolcommits/compare/v0.6.5...v0.6.6
[0.6.5]: https://github.com/lolcommits/lolcommits/compare/v0.6.4...v0.6.5
[0.6.4]: https://github.com/lolcommits/lolcommits/compare/v0.6.3...v0.6.4
[0.6.3]: https://github.com/lolcommits/lolcommits/compare/v0.6.2...v0.6.3
[0.6.2]: https://github.com/lolcommits/lolcommits/compare/v0.6.1...v0.6.2
[0.6.1]: https://github.com/lolcommits/lolcommits/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/lolcommits/lolcommits/compare/v0.5.9...v0.6.0
[0.5.9]: https://github.com/lolcommits/lolcommits/compare/v0.5.8...v0.5.9
[0.5.8]: https://github.com/lolcommits/lolcommits/compare/v0.5.7...v0.5.8
[0.5.7]: https://github.com/lolcommits/lolcommits/compare/v0.5.6...v0.5.7
[0.5.6]: https://github.com/lolcommits/lolcommits/compare/v0.5.5...v0.5.6
[0.5.5]: https://github.com/lolcommits/lolcommits/compare/v0.5.4...v0.5.5
[0.5.4]: https://github.com/lolcommits/lolcommits/compare/v0.5.3...v0.5.4
[0.5.3]: https://github.com/lolcommits/lolcommits/compare/v0.5.2...v0.5.3
[0.5.2]: https://github.com/lolcommits/lolcommits/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/lolcommits/lolcommits/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/lolcommits/lolcommits/compare/v0.4.9...v0.5.0
[#9]: https://github.com/lolcommits/lolcommits/pull/9
[#21]: https://github.com/lolcommits/lolcommits/pull/21
[#31]: https://github.com/lolcommits/lolcommits/pull/31
[#43]: https://github.com/lolcommits/lolcommits/pull/43
[#50]: https://github.com/lolcommits/lolcommits/pull/50
[#51]: https://github.com/lolcommits/lolcommits/pull/51
[#73]: https://github.com/lolcommits/lolcommits/pull/73
[#82]: https://github.com/lolcommits/lolcommits/pull/82
[#83]: https://github.com/lolcommits/lolcommits/pull/83
[#87]: https://github.com/lolcommits/lolcommits/pull/87
[#89]: https://github.com/lolcommits/lolcommits/pull/89
[#90]: https://github.com/lolcommits/lolcommits/pull/90
[#91]: https://github.com/lolcommits/lolcommits/pull/91
[#92]: https://github.com/lolcommits/lolcommits/pull/92
[#93]: https://github.com/lolcommits/lolcommits/pull/93
[#94]: https://github.com/lolcommits/lolcommits/pull/94
[#95]: https://github.com/lolcommits/lolcommits/pull/95
[#104]: https://github.com/lolcommits/lolcommits/pull/104
[#105]: https://github.com/lolcommits/lolcommits/pull/105
[#107]: https://github.com/lolcommits/lolcommits/pull/107
[#108]: https://github.com/lolcommits/lolcommits/pull/108
[#109]: https://github.com/lolcommits/lolcommits/pull/109
[#112]: https://github.com/lolcommits/lolcommits/pull/112
[#112]: https://github.com/lolcommits/lolcommits/pull/112
[#114]: https://github.com/lolcommits/lolcommits/pull/114
[#119]: https://github.com/lolcommits/lolcommits/pull/119
[#123]: https://github.com/lolcommits/lolcommits/pull/123
[#125]: https://github.com/lolcommits/lolcommits/pull/125
[#133]: https://github.com/lolcommits/lolcommits/pull/133
[#136]: https://github.com/lolcommits/lolcommits/pull/136
[#139]: https://github.com/lolcommits/lolcommits/pull/139
[#145]: https://github.com/lolcommits/lolcommits/pull/145
[#146]: https://github.com/lolcommits/lolcommits/pull/146
[#151]: https://github.com/lolcommits/lolcommits/pull/151
[#154]: https://github.com/lolcommits/lolcommits/pull/154
[#155]: https://github.com/lolcommits/lolcommits/pull/155
[#156]: https://github.com/lolcommits/lolcommits/pull/156
[#159]: https://github.com/lolcommits/lolcommits/pull/159
[#159]: https://github.com/lolcommits/lolcommits/pull/159
[#160]: https://github.com/lolcommits/lolcommits/pull/160
[#163]: https://github.com/lolcommits/lolcommits/pull/163
[#168]: https://github.com/lolcommits/lolcommits/pull/168
[#171]: https://github.com/lolcommits/lolcommits/pull/171
[#173]: https://github.com/lolcommits/lolcommits/pull/173
[#174]: https://github.com/lolcommits/lolcommits/pull/174
[#175]: https://github.com/lolcommits/lolcommits/pull/175
[#176]: https://github.com/lolcommits/lolcommits/pull/176
[#177]: https://github.com/lolcommits/lolcommits/pull/177
[#178]: https://github.com/lolcommits/lolcommits/pull/178
[#179]: https://github.com/lolcommits/lolcommits/pull/179
[#180]: https://github.com/lolcommits/lolcommits/pull/180
[#181]: https://github.com/lolcommits/lolcommits/pull/181
[#183]: https://github.com/lolcommits/lolcommits/pull/183
[#184]: https://github.com/lolcommits/lolcommits/pull/184
[#186]: https://github.com/lolcommits/lolcommits/pull/186
[#188]: https://github.com/lolcommits/lolcommits/pull/188
[#189]: https://github.com/lolcommits/lolcommits/pull/189
[#192]: https://github.com/lolcommits/lolcommits/pull/192
[#193]: https://github.com/lolcommits/lolcommits/pull/193
[#194]: https://github.com/lolcommits/lolcommits/pull/194
[#195]: https://github.com/lolcommits/lolcommits/pull/195
[#196]: https://github.com/lolcommits/lolcommits/pull/196
[#202]: https://github.com/lolcommits/lolcommits/pull/202
[#206]: https://github.com/lolcommits/lolcommits/pull/206
[#207]: https://github.com/lolcommits/lolcommits/pull/207
[#208]: https://github.com/lolcommits/lolcommits/pull/208
[#212]: https://github.com/lolcommits/lolcommits/pull/212
[#215]: https://github.com/lolcommits/lolcommits/pull/215
[#223]: https://github.com/lolcommits/lolcommits/pull/223
[#224]: https://github.com/lolcommits/lolcommits/pull/224
[#225]: https://github.com/lolcommits/lolcommits/pull/225
[#226]: https://github.com/lolcommits/lolcommits/pull/226
[#228]: https://github.com/lolcommits/lolcommits/pull/228
[#229]: https://github.com/lolcommits/lolcommits/pull/229
[#231]: https://github.com/lolcommits/lolcommits/pull/231
[#232]: https://github.com/lolcommits/lolcommits/pull/232
[#233]: https://github.com/lolcommits/lolcommits/pull/233
[#234]: https://github.com/lolcommits/lolcommits/pull/234
[#235]: https://github.com/lolcommits/lolcommits/pull/235
[#236]: https://github.com/lolcommits/lolcommits/pull/236
[#237]: https://github.com/lolcommits/lolcommits/pull/237
[#240]: https://github.com/lolcommits/lolcommits/pull/240
[#241]: https://github.com/lolcommits/lolcommits/pull/241
[#244]: https://github.com/lolcommits/lolcommits/pull/244
[#244]: https://github.com/lolcommits/lolcommits/pull/244
[#246]: https://github.com/lolcommits/lolcommits/pull/246
[#250]: https://github.com/lolcommits/lolcommits/pull/250
[#251]: https://github.com/lolcommits/lolcommits/pull/251
[#252]: https://github.com/lolcommits/lolcommits/pull/252
[#254]: https://github.com/lolcommits/lolcommits/pull/254
[#256]: https://github.com/lolcommits/lolcommits/pull/256
[#258]: https://github.com/lolcommits/lolcommits/pull/258
[#263]: https://github.com/lolcommits/lolcommits/pull/263
[#266]: https://github.com/lolcommits/lolcommits/pull/266
[#266]: https://github.com/lolcommits/lolcommits/pull/266
[#267]: https://github.com/lolcommits/lolcommits/pull/267
[#270]: https://github.com/lolcommits/lolcommits/pull/270
[#272]: https://github.com/lolcommits/lolcommits/pull/272
[#276]: https://github.com/lolcommits/lolcommits/pull/276
[#278]: https://github.com/lolcommits/lolcommits/pull/278
[#279]: https://github.com/lolcommits/lolcommits/pull/279
[#280]: https://github.com/lolcommits/lolcommits/pull/280
[#282]: https://github.com/lolcommits/lolcommits/pull/282
[#283]: https://github.com/lolcommits/lolcommits/pull/283
[#284]: https://github.com/lolcommits/lolcommits/pull/284
[#286]: https://github.com/lolcommits/lolcommits/pull/286
[#289]: https://github.com/lolcommits/lolcommits/pull/289
[#292]: https://github.com/lolcommits/lolcommits/pull/292
[#294]: https://github.com/lolcommits/lolcommits/pull/294
[#296]: https://github.com/lolcommits/lolcommits/pull/296
[#298]: https://github.com/lolcommits/lolcommits/pull/298
[#301]: https://github.com/lolcommits/lolcommits/pull/301
[#302]: https://github.com/lolcommits/lolcommits/pull/302
[#303]: https://github.com/lolcommits/lolcommits/pull/303
[#304]: https://github.com/lolcommits/lolcommits/pull/304
[#308]: https://github.com/lolcommits/lolcommits/pull/308
[#309]: https://github.com/lolcommits/lolcommits/pull/309
[#313]: https://github.com/lolcommits/lolcommits/pull/313
[#313]: https://github.com/lolcommits/lolcommits/pull/313
[#317]: https://github.com/lolcommits/lolcommits/pull/317
[#318]: https://github.com/lolcommits/lolcommits/pull/318
[#320]: https://github.com/lolcommits/lolcommits/pull/320
[#321]: https://github.com/lolcommits/lolcommits/pull/321
[#323]: https://github.com/lolcommits/lolcommits/pull/323
[#325]: https://github.com/lolcommits/lolcommits/pull/325
[#326]: https://github.com/lolcommits/lolcommits/pull/326
[#328]: https://github.com/lolcommits/lolcommits/pull/328
[#329]: https://github.com/lolcommits/lolcommits/pull/329
[#330]: https://github.com/lolcommits/lolcommits/pull/330
[#331]: https://github.com/lolcommits/lolcommits/pull/331
[#332]: https://github.com/lolcommits/lolcommits/pull/332
[#338]: https://github.com/lolcommits/lolcommits/pull/338
[#339]: https://github.com/lolcommits/lolcommits/pull/339
[#340]: https://github.com/lolcommits/lolcommits/pull/340
[#341]: https://github.com/lolcommits/lolcommits/pull/341
[#342]: https://github.com/lolcommits/lolcommits/pull/342
[#347]: https://github.com/lolcommits/lolcommits/pull/347
[#348]: https://github.com/lolcommits/lolcommits/pull/348
[#349]: https://github.com/lolcommits/lolcommits/pull/349
[#351]: https://github.com/lolcommits/lolcommits/pull/351
[#352]: https://github.com/lolcommits/lolcommits/pull/352
[#353]: https://github.com/lolcommits/lolcommits/pull/353
[#354]: https://github.com/lolcommits/lolcommits/pull/354
[#355]: https://github.com/lolcommits/lolcommits/pull/355
[#356]: https://github.com/lolcommits/lolcommits/pull/356
[#357]: https://github.com/lolcommits/lolcommits/pull/357
[#358]: https://github.com/lolcommits/lolcommits/pull/358
[#359]: https://github.com/lolcommits/lolcommits/pull/359
[#360]: https://github.com/lolcommits/lolcommits/pull/360
[#361]: https://github.com/lolcommits/lolcommits/pull/361
[#363]: https://github.com/lolcommits/lolcommits/pull/363
[#365]: https://github.com/lolcommits/lolcommits/pull/365
[#366]: https://github.com/lolcommits/lolcommits/pull/366
[#367]: https://github.com/lolcommits/lolcommits/pull/367
[#369]: https://github.com/lolcommits/lolcommits/pull/369
[#377]: https://github.com/lolcommits/lolcommits/pull/377
[#384]: https://github.com/lolcommits/lolcommits/pull/384
[#385]: https://github.com/lolcommits/lolcommits/pull/385
[#386]: https://github.com/lolcommits/lolcommits/pull/386
[#392]: https://github.com/lolcommits/lolcommits/pull/392
[#394]: https://github.com/lolcommits/lolcommits/pull/394
[#398]: https://github.com/lolcommits/lolcommits/pull/398
[#399]: https://github.com/lolcommits/lolcommits/pull/399
[#400]: https://github.com/lolcommits/lolcommits/pull/400
[#401]: https://github.com/lolcommits/lolcommits/pull/401
[#402]: https://github.com/lolcommits/lolcommits/pull/402
[#405]: https://github.com/lolcommits/lolcommits/pull/405
