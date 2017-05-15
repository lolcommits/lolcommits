Feature: History command

  The history commands allow the user to examine previously captured lolcommits.

  Background:
    Given a mocked home directory

  Scenario: Help should format nicely on a 80x24 terminal
    When I get help for "lolcommits history"
    Then the output should not contain any lines longer than 80

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

  @in-tempdir
  Scenario: last command should fail gracefully if not in a lolrepo
    Given I am in a directory named "gitsuxcvs4eva"
    When I run `lolcommits --last`
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

  @in-tempdir
  Scenario: browse command should fail gracefully when not in a lolrepo
    Given I am in a directory named "gitsuxcvs4eva"
    When I run `lolcommits --browse`
    Then the output should contain:
      """
      You don't appear to be in a directory of a supported vcs project.
      """
    And the exit status should be 1

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

  Scenario: generate gif should store in its own archive directory
    Given I am in a git repo named "giffy" with lolcommits enabled
      And a loldir named "giffy" with 2 lolimages
    When I successfully run `lolcommits --timelapse`
    Then the output should contain "Generating animated gif."
      And a directory named "~/.lolcommits/giffy/archive" should exist
      And a file named "~/.lolcommits/giffy/archive/archive.gif" should exist

  Scenario: generate gif with argument 'today'
    Given I am in a git repo named "sunday" with lolcommits enabled
      And a loldir named "sunday" with 2 lolimages
    When I successfully run `lolcommits --timelapse --period today`
    Then there should be exactly 1 gif in "~/.lolcommits/sunday/archive"




