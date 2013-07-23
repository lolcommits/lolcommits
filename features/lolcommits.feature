Feature: Basic UI functionality

  Scenario: App just runs
    When I get help for "lolcommits"
    Then the exit status should be 0
    And the banner should be present

  Scenario: Help should show the animate option on a Mac platform
    Given I am using a "Mac" platform
    When I get help for "lolcommits"
    Then the following options should be documented:
      |--animate|which is optional|
      |-a       |which is optional|

  Scenario: Help should not show the animate option on a Linux plaftorm
    Given I am using a "Linux" platform
    When I get help for "lolcommits"
    Then the output should not match /\-a\, \-\-animate\=SECONDS/

  Scenario: Enable in a naked git repository
    Given a git repository named "loltest" with no "post-commit" hook
    When I cd to "loltest"
    And I successfully run `lolcommits --enable`
    Then the output should contain "installed lolcommmit hook as:"
      And the output should contain "(to remove later, you can use: lolcommits --disable)"
      And a file named ".git/hooks/post-commit" should exist
      And the exit status should be 0

  Scenario: Disable in a enabled git repository
    Given I am in a git repository named "lolenabled" with lolcommits enabled
    When I successfully run `lolcommits --disable`
    Then the output should contain "removed"
      And a file named ".git/hooks/post-commit" should not exist
      And the exit status should be 0

  Scenario: Trying to enable while not in a git repo fails
    Given I am in a directory named "svnrulez"
    When I run `lolcommits --enable`
    Then the output should contain "You don't appear to be in the base directory of a git project."
      And the exit status should be 1

  Scenario: Capture doesnt break in forked mode
    Given I am in a git repository named "testforkcapture"
    And I do a git commit
    When I successfully run `lolcommits --capture --fork`
    Then there should be exactly 1 pid in "../.lolcommits/testforkcapture"
    When I wait for the child process to exit in "testforkcapture"
    Then the output should contain "*** Preserving this moment in history."
      And a directory named "../.lolcommits/testforkcapture" should exist
      And a file named "../.lolcommits/testforkcapture/tmp_snapshot.jpg" should not exist
      And there should be exactly 1 jpg in "../.lolcommits/testforkcapture"

  Scenario: Commiting in an enabled repo triggers successful capture
    Given I am in a git repository named "testcapture" with lolcommits enabled
    When I do a git commit
    Then the output should contain "*** Preserving this moment in history."
      And a directory named "../.lolcommits/testcapture" should exist
      And a file named "../.lolcommits/testcapture/tmp_snapshot.jpg" should not exist
      And there should be exactly 1 jpg in "../.lolcommits/testcapture"

  Scenario: Commiting in an enabled repo subdirectory triggers successful capture of parent repo
    Given I am in a git repository named "testcapture" with lolcommits enabled
      And a directory named "subdir"
      And an empty file named "subdir/FOOBAR"
    When I cd to "subdir/"
      And I do a git commit
    Then the output should contain "*** Preserving this moment in history."
      And a directory named "../../.lolcommits/testcapture" should exist
      And a directory named "../../.lolcommits/subdir" should not exist
      And there should be exactly 1 jpg in "../../.lolcommits/testcapture"

  Scenario: Show plugins
    When I successfully run `lolcommits --plugins`
    Then the output should contain a list of plugins

  #
  # a stab at recreating ken's scenarios with native aruba steps, not quite there yet in terms
  # of elegance, but its passing so might as well leave in for now.
  #
  Scenario: Configuring plugin (with native aruba steps)
    Given a git repository named "config-test"
    When I cd to "config-test"
    And I run `lolcommits --config` interactively
    When I type "loltext"
    When I type "true"
    Then the output should contain a list of plugins
    And the output should contain "Name of plugin to configure:"
    Then the output should contain "enabled:"
    Then the output should contain "Successfully Configured"
    And a file named "../.lolcommits/config-test/config.yml" should exist
    When I successfully run `lolcommits --show-config`
    Then the output should contain "loltext:"
    And the output should contain "enabled: true"

  Scenario: Configuring Plugin
    Given a git repository named "config-test"
    When I cd to "config-test"
    And I run `lolcommits --config` and wait for output
    When I enter "loltext" for "Name of plugin to configure"
    And I enter "true" for "enabled"
    Then I should be presented "Successfully Configured"
    And a file named "../.lolcommits/config-test/config.yml" should exist
    When I successfully run `lolcommits --show-config`
    Then the output should contain "loltext:"
    And the output should contain "enabled: true"

  Scenario: Configuring Plugin In Test Mode
    Given a git repository named "testmode-config-test"
    When I cd to "testmode-config-test"
    And I run `lolcommits --config --test` and wait for output
    And I enter "loltext" for "Name of plugin to configure"
    And I enter "true" for "enabled"
    Then I should be presented "Successfully Configured"
    And a file named "../.lolcommits/test/config.yml" should exist
    When I successfully run `lolcommits --test --show-config`
    Then the output should contain "loltext:"
    And the output should contain "enabled: true"

  Scenario: test capture should work regardless of whether in a git repository
    Given I am in a directory named "nothingtoseehere"
    When I run `lolcommits --test --capture`
    Then the output should contain "*** Capturing in test mode."
      And the output should not contain "path does not exist (ArgumentError)"
      And the exit status should be 0

  Scenario: test capture should store in its own test directory
    Given I am in a git repository named "randomgitrepo" with lolcommits enabled
    When I successfully run `lolcommits --test --capture`
    Then a directory named "../.lolcommits/test" should exist
    And a directory named "../.lolcommits/randomgitrepo" should not exist

  Scenario: last command should work properly when in a lolrepo
    Given a git repository named "randomgitrepo"
      And a loldir named "randomgitrepo" with 2 lolimages
      And I cd to "randomgitrepo"
    When I run `lolcommits --last`
    Then the exit status should be 0

  Scenario: last command should fail gracefully if not in a lolrepo
    Given I am in a directory named "gitsuxcvs4eva"
    When I run `lolcommits --last`
    Then the output should contain "Can't do that since we're not in a valid git repository!"
    And the exit status should be 1

  Scenario: last command should fail gracefully if zero lolimages in lolrepo
    Given a git repository named "randomgitrepo"
    And a loldir named "randomgitrepo" with 0 lolimages
    And I cd to "randomgitrepo"
    When I run `lolcommits --last`
    Then the output should contain "No lolcommits have been captured for this repository yet."
    Then the exit status should be 1

  Scenario: browse command should work properly when in a lolrepo
    Given a git repository named "randomgitrepo"
      And a loldir named "randomgitrepo" with 2 lolimages
      And I cd to "randomgitrepo"
    When I run `lolcommits --browse`
    Then the exit status should be 0

  Scenario: browse command should fail gracefully when not in a lolrepo
    Given I am in a directory named "gitsuxcvs4eva"
    When I run `lolcommits --browse`
    Then the output should contain "Can't do that since we're not in a valid git repository!"
      And the exit status should be 1

  Scenario: handle commit messages with quotation marks
    Given I am in a git repository named "shellz" with lolcommits enabled
    When I successfully run `git commit --allow-empty -m 'i hate \"air quotes\" dont you'`
    Then the exit status should be 0
      And there should be exactly 1 jpg in "../.lolcommits/shellz"

  Scenario: generate gif should store in its own archive directory
    Given I am in a git repository named "randomgitrepo" with lolcommits enabled
      And a loldir named "randomgitrepo" with 2 lolimages
    When I successfully run `lolcommits -g`
    Then the output should contain "Generating animated gif."
    And a directory named "../.lolcommits/randomgitrepo/archive" should exist
    And a file named "../.lolcommits/randomgitrepo/archive/archive.gif" should exist

  Scenario: generate gif with argument 'today'
    Given I am in a git repository named "randomgitrepo" with lolcommits enabled
      And a loldir named "randomgitrepo" with 2 lolimages
    When I successfully run `lolcommits -g today`
      And there should be exactly 1 gif in "../.lolcommits/randomgitrepo/archive"

  @mac-only
  Scenario: should generate an animated gif on the Mac platform
    Given I am in a git repository named "testanimatedcapture"
      And I do a git commit
      And I am using a "Mac" platform
    When I run `lolcommits --capture --animate=1`
    Then the output should contain "*** Preserving this moment in history."
      And a directory named "../.lolcommits/testanimatedcapture" should exist
      And a file named "../.lolcommits/testanimatedcapture/tmp_video.avi" should not exist
      And a directory named "../.lolcommits/testanimatedcapture/tmp_frames" should not exist
      And there should be exactly 1 gif in "../.lolcommits/testanimatedcapture"

  @fake-no-ffmpeg
  Scenario: gracefully fail when ffmpeg is not installed and animate option is used
    Given I am using a "Mac" platform
    When I run `lolcommits --animate=3`
    Then the output should contain "ffmpeg does not appear to be properly installed"
    And the exit status should be 1
