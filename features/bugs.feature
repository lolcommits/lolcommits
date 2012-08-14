Feature: Bug regression testing
  As a developer
  I want to ensure fixed bugs stay fixed
  So that I don't have to fix them again!

  #
  # issue #58, https://github.com/mroth/lolcommits/issues/58
  #
  Scenario: handle git repos with spaces in directory name
    Given I am in a git repository named "test lolol" with lolcommits enabled
    And I successfully run `git commit --allow-empty -m 'can haz commit'`
    Then the output should contain "*** Preserving this moment in history."
    And a directory named "../.lolcommits/test-lolol" should exist


  #
  # issue #53, https://github.com/mroth/lolcommits/issues/53
  #
  #@fake-root @simulate-env
  #Scenario: error if can't read font file
  #  Given "fonts/Impact.ttf" packaged file is not readable
  #  When I run `lolcommits --test --capture`
  #  Then the output should contain "Couldn't properly read Impact font from gem package"
  #  And the exit status should be 1

