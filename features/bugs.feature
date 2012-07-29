Feature: Bug regression testing
  As a developer
  I want to ensure fixed bugs stay fixed
  So that I don't have to fix them again!

  #
  # issue #58, https://github.com/mroth/lolcommits/issues/58
  #
  Scenario: handle git repos with spaces in directory name
    Given a git repository named "test lolol"
    And an empty file named "test lolol/FOOBAR"
    
    When I cd to "test lolol"
    And I successfully run `lolcommits --enable`
    And I successfully run `git add .`
    And I successfully run `git commit -m 'can haz commit'`
    Then the output should contain "*** Preserving this moment in history."
    And a directory named "tmp/aruba/.lolcommits/test-lolol" should exist


  #
  # issue #53, https://github.com/mroth/lolcommits/issues/53
  #
  #@fake-root @simulate-env
  #Scenario: error if can't read font file
  #  Given "fonts/Impact.ttf" packaged file is not readable
  #  When I run `lolcommits --test --capture`
  #  Then the output should contain "Couldn't properly read Impact font from gem package"
  #  And the exit status should be 1

