Feature: Basic UI functionality

  Background:
    Given a mocked home directory

  Scenario: App just runs
    When I get help for "lolcommits"
    Then the exit status should be 0
    And the banner should be present

  Scenario: Help should show the animate option on a Mac platform
    Given I am using a "darwin" platform
    When I get help for "lolcommits"
    Then the following options should be documented:
      | --animate | which is optional |
      | -a        | which is optional |

  Scenario: Help should not show the animate option on a Windows plaftorm
    Given I am using a "win32" platform
    When I get help for "lolcommits"
    Then the output should not match /\-a\, \-\-animate\=SECONDS/

  Scenario: Enable in a naked git repo
    Given I am in a git repo
    When I run `lolcommits --enable`
    Then the output should contain "installed lolcommit hook to:"
      And the lolcommits git post-commit hook should be properly installed
      And the exit status should be 0

  Scenario: Enable in a git repo that already has a git post-commit hook
    Given I am in a git repo
    And a git post-commit hook with "#!/bin/sh\n\n/my/own/script"
    When I run `lolcommits --enable`
    Then the output should contain "installed lolcommit hook to:"
      And the lolcommits git post-commit hook should be properly installed
      And the git post-commit hook should contain "#!/bin/sh"
      And the git post-commit hook should contain "/my/own/script"
      And the exit status should be 0

  Scenario: Enable in a git repo that has git post-commit hook with a bad shebang
    Given I am in a git repo
    And a git post-commit hook with "#!/bin/ruby"
    And I run `lolcommits --enable`
      Then the output should contain "doesn't start with a good shebang"
      And the git post-commit hook should not contain "lolcommits --capture"
      And the exit status should be 1

  Scenario: Enable in a git repo passing capture arguments
    Given I am in a git repo
    When I run `lolcommits --enable -w 5 --fork --stealth --device 'My Devce'`
    Then the git post-commit hook should contain "lolcommits --capture --delay 5 --fork --stealth --device 'My Devce'"
    And the exit status should be 0

  Scenario: Disable in a enabled git repo
    Given I am in a git repo with lolcommits enabled
    When I run `lolcommits --disable`
    Then the output should contain "uninstalled"
    And a file named ".git/hooks/post-commit" should exist
    And the exit status should be 0

  Scenario: Trying to enable while not in a git repo fails
    Given I am in a directory named "svnrulez"
    When I run `lolcommits --enable`
    Then the output should contain:
      """
      You don't appear to be in the base directory of a supported vcs project.
      """
    And the exit status should be 1

  # flakey test sometimes fails: https://travis-ci.org/mroth/lolcommits/jobs/312629988#L620
  # Scenario: Capture doesnt break in forked mode
  #   Given I am in a git repo named "forked"
  #   And I do a git commit
  #   When I run `lolcommits --capture --fork`
  #   Then there should be exactly 1 pid in "~/.lolcommits/forked"
  #   When I wait for the child process to exit in "forked"
  #   Then a directory named "~/.lolcommits/forked" should exist
  #     And a file named "~/.lolcommits/forked/tmp_snapshot.jpg" should not exist
  #     And there should be exactly 1 jpg in "~/.lolcommits/forked"

  Scenario: Commiting in an enabled git repo triggers successful capture
    Given I am in a git repo named "myrepo" with lolcommits enabled
    When I do a git commit
    Then the output should contain "*** Preserving this moment in history."
      And a directory named "~/.lolcommits/myrepo" should exist
      And a file named "~/.lolcommits/myrepo/tmp_snapshot.jpg" should not exist
      And there should be exactly 1 jpg in "~/.lolcommits/myrepo"

  Scenario: Commiting in enabled git repo subdirectory triggers successful capture
    Given I am in a git repo named "testcapture" with lolcommits enabled
      And a directory named "subdir"
      And an empty file named "subdir/FOOBAR"
    When I cd to "subdir/"
      And I do a git commit
    Then the output should contain "*** Preserving this moment in history."
      And a directory named "~/.lolcommits/testcapture" should exist
      And a directory named "~/.lolcommits/subdir" should not exist
      And there should be exactly 1 jpg in "~/.lolcommits/testcapture"

  Scenario: Stealth mode does not alert the user
    Given I am in a git repo named "teststealth"
    And I do a git commit
    When I run `lolcommits --stealth --capture`
    Then the output should not contain "*** Preserving this moment in history."
    And there should be exactly 1 jpg in "~/.lolcommits/teststealth"

  Scenario: Commiting in stealth mode captures without alerting the committer
    Given I am in a git repo with lolcommits enabled
    And I have environment variable LOLCOMMITS_STEALTH set to 1
    When I do a git commit
    Then the output should not contain "*** Preserving this moment in history."
    And there should be exactly 1 jpg in its loldir

  Scenario: Show plugins
    When I run `lolcommits --plugins`
    Then the output should contain a list of plugins

  Scenario: Configuring loltext plugin in test mode affects test loldir not repo loldir
    Given I am in a git repo named "testmode-config-test"
    When I run `lolcommits --config --test -p loltext` interactively
      Then I type "false"
      Then the output should contain "Disabling plugin: loltext - answer with 'true' to enable & configure"
    And a file named "~/.lolcommits/test/config.yml" should exist
    When I run `lolcommits --test --show-config`
    Then the output should match /loltext:\s+:enabled: false/

  Scenario: test capture should work regardless of whether in a lolrepo
    Given I am in a directory named "nothingtoseehere"
    When I run `lolcommits --test --capture`
    Then the output should contain "*** Capturing in test mode."
      And the output should not contain "path does not exist (ArgumentError)"
      And the exit status should be 0

  Scenario: test capture should store in its own test directory
    Given I am in a git repo named "randomgitrepo" with lolcommits enabled
    When I run `lolcommits --test --capture`
    Then a directory named "~/.lolcommits/test" should exist
    And a directory named "~/.lolcommits/randomgitrepo" should not exist

  Scenario: last command should work properly when in a git lolrepo
    Given I am in a git repo
    And its loldir has 2 lolimages
    When I run `lolcommits --last`
    Then the exit status should be 0

  Scenario: last command should work properly when in a git lolrepo subdirectory
    Given I am in a git repo
      And its loldir has 2 lolimages
      And a directory named "randomdir"
      And I cd to "randomdir"
    When I run `lolcommits --last`
    Then the output should not contain:
      """
      You don't appear to be in a directory of a supported vcs project.
      """
    And the exit status should be 0

  @no-repo-dir
  Scenario: last command should fail gracefully if not in a repo
    When I run `lolcommits --last`
    Then the output should contain:
      """
      You don't appear to be in a directory of a supported vcs project.
      """
    And the exit status should be 1

  @no-repo-dir
  Scenario: Configuring loltext plugin if not in a repo
    When I run `lolcommits --config`
    Then the output should contain:
      """
      You don't appear to be in a directory of a supported vcs project.
      """
    And the exit status should be 1

  @no-repo-dir
  Scenario: browse command should fail gracefully when not in a repo
    When I run `lolcommits --browse`
    Then the output should contain:
      """
      You don't appear to be in a directory of a supported vcs project.
      """
    And the exit status should be 1

  Scenario: last command should fail gracefully if zero lolimages in lolrepo
    Given I am in a git repo
    And its loldir has 0 lolimages
    When I run `lolcommits --last`
    Then the output should contain:
      """
      No lolcommits have been captured for this repository yet.
      """
    Then the exit status should be 1

  Scenario: browse command should work properly when in a git lolrepo
    Given I am in a git repo
    And its loldir has 2 lolimages
    When I run `lolcommits --browse`
    Then the exit status should be 0

  Scenario: browse command should work properly when in a git lolrepo subdirectory
    Given I am in a git repo
      And its loldir has 2 lolimages
      And a directory named "subdir"
      And I cd to "subdir"
    When I run `lolcommits --browse`
    Then the output should not contain:
      """
      You don't appear to be in a directory of a supported vcs project.
      """
    And the exit status should be 0

  Scenario: handle git commit messages with quotation marks
    Given I am in a git repo with lolcommits enabled
    When I run `git commit --allow-empty -m 'no "air quotes" bae'`
    Then the exit status should be 0
    And there should be exactly 1 jpg in its loldir

  Scenario: generate gif should store in its own archive directory
    Given I am in a git repo named "giffy" with lolcommits enabled
      And a loldir named "giffy" with 2 lolimages
    When I run `lolcommits --timelapse`
    Then the output should contain "Generating animated gif."
      And a directory named "~/.lolcommits/giffy/archive" should exist
      And a file named "~/.lolcommits/giffy/archive/archive.gif" should exist

  Scenario: generate gif with argument 'today'
    Given I am in a git repo named "sunday" with lolcommits enabled
      And a loldir named "sunday" with 2 lolimages
    When I run `lolcommits --timelapse --period today`
    Then there should be exactly 1 gif in "~/.lolcommits/sunday/archive"

  @mac-only
  Scenario: should generate an animated gif on the Mac platform
    Given I am in a git repo named "animate"
      And I do a git commit
    When I run `lolcommits --capture --animate=1`
    Then the output should contain "*** Preserving this moment in history."
      And a directory named "~/.lolcommits/animate" should exist
      And a file named "~/.lolcommits/animate/tmp_video.mov" should not exist
      And a directory named "~/.lolcommits/animate/tmp_frames" should not exist
      And there should be exactly 1 gif in "~/.lolcommits/animate"

  @fake-no-ffmpeg
  Scenario: gracefully fail when ffmpeg not installed and --animate is used
    Given I am using a "darwin" platform
    When I run `lolcommits -c --animate 3`
    Then the output should contain:
      """
      ffmpeg does not appear to be properly installed
      """
    And the exit status should be 1

  Scenario: Enable on windows platform setting PATH in git post-commit hook
    Given I am using a "win32" platform
      And I am in a git repo
    When I run `lolcommits --enable`
    Then the git post-commit hook should contain "set path"
    And the exit status should be 0

  Scenario: Enable in a naked mercurial repo
    Given I am in a mercurial repo
    When I run `lolcommits --enable`
    Then the output should contain "installed lolcommit hook to:"
    And the lolcommits mercurial post-commit hook should be properly installed
    And the exit status should be 0

  Scenario: Enable in a mercurial repo that already has a mercurial post-commit hook
    Given I am in a mercurial repo
    And a mercurial post-commit hook with "[hooks]\npost-commit.mine = /my/own/script"
    When I run `lolcommits --enable`
    Then the output should contain "installed lolcommit hook to:"
    And the lolcommits mercurial post-commit hook should be properly installed
    And the mercurial post-commit hook should contain "post-commit.mine = /my/own/script"
    And the exit status should be 0

  Scenario: Enable in a mercurial repo passing capture arguments
    Given I am in a mercurial repo
    When I run `lolcommits --enable -w 5 --fork`
    Then the mercurial post-commit hook should contain "lolcommits --capture --delay 5 --fork"
    And the exit status should be 0

  Scenario: Disable in a enabled mercurial repo
    Given I am in a mercurial repo with lolcommits enabled
    When I run `lolcommits --disable`
    Then the output should contain "uninstalled"
    And a file named ".hg/hgrc" should exist
    And the exit status should be 0

  Scenario: Commiting in an enabled mercurial repo triggers successful capture
    Given I am in a mercurial repo named "myrepo" with lolcommits enabled
    When I do a mercurial commit
    Then the output should contain "*** Preserving this moment in history."
    And a directory named "~/.lolcommits/myrepo" should exist
    And a file named "~/.lolcommits/myrepo/tmp_snapshot.jpg" should not exist
    And there should be exactly 1 jpg in "~/.lolcommits/myrepo"

  Scenario: Commiting in enabled mercurial repo subdirectory triggers successful capture
    Given I am in a mercurial repo named "testcapture" with lolcommits enabled
    And a directory named "subdir"
    And an empty file named "subdir/FOOBAR"
    When I cd to "subdir/"
    And I do a mercurial commit
    Then the output should contain "*** Preserving this moment in history."
    And a directory named "~/.lolcommits/testcapture" should exist
    And a directory named "~/.lolcommits/subdir" should not exist
    And there should be exactly 1 jpg in "~/.lolcommits/testcapture"

  Scenario: last command should work properly when in a mercurial lolrepo
    Given I am in a mercurial repo
    And its loldir has 2 lolimages
    When I run `lolcommits --last`
    Then the exit status should be 0

  Scenario: last command should work properly when in a mercurial lolrepo subdirectory
    Given I am in a mercurial repo
    And its loldir has 2 lolimages
    And a directory named "randomdir"
    And I cd to "randomdir"
    When I run `lolcommits --last`
    Then the output should not contain:
      """
      You don't appear to be in a directory of a supported vcs project.
      """
    And the exit status should be 0

  Scenario: browse command should work properly when in a mercurial lolrepo
    Given I am in a mercurial repo
    And its loldir has 2 lolimages
    When I run `lolcommits --browse`
    Then the exit status should be 0

  Scenario: browse command should work properly when in a mercurial lolrepo subdirectory
    Given I am in a mercurial repo
    And its loldir has 2 lolimages
    And a directory named "subdir"
    And I cd to "subdir"
    When I run `lolcommits --browse`
    Then the output should not contain:
      """
      You don't appear to be in a directory of a supported vcs project.
      """
    And the exit status should be 0

  Scenario: handle mercurial commit messages with quotation marks
    Given I am in a mercurial repo with lolcommits enabled
    When I run `touch meh`
    And I run `hg add meh`
    And I run `hg commit -m 'no "air quotes" bae'`
    Then the exit status should be 0
    And there should be exactly 1 jpg in its loldir
