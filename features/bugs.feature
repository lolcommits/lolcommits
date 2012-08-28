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
  # issue #68, https://github.com/mroth/lolcommits/issues/68
  #
  #@focus
  #Scenario: Don't trigger capture during a git rebase
  #  Given I am in a git repository named "yuh8history" with lolcommits enabled
  #    And I do a git commit
  #    And I successfully run `git tag 'vA'`
  #    And I do a git commit
  #    And I successfully run `git tag 'vB'`
  #    And I do a git commit
  #    And I successfully run `git tag 'vC'`
  #    And I do a git commit
  #    And I successfully run `git tag 'vD'`
  #    And I do a git commit
  #    And I successfully run `git tag 'vE'`
  #    And I do a git commit
  #    And I successfully run `git tag 'vF'`
  #    And I successfully run `git checkout vB`
  #    And I successfully run `git reset --soft master`
  #    And I successfully run `git merge --squash vD`
  #  When I successfully run `git rebase --onto $(cat .git/HEAD) vE vF`
  #  # When I successfully run `git rebase placeholder`
  #  Then there should be 4 commit entries in the git log
  #  # But there should be exactly 5 jpgs in "../.lolcommits/yuh8history"

    # Given I am in a git repository named "yuh8history" with lolcommits enabled
    #   And I do 2 git commits
    #   And I successfully run `git branch middle`
    #   And I do 2 git commits
    #   And I successfully run `git branch placeholder`
    #   And I successfully run `git checkout middle`
    #   And I do 2 git commits
    # When I successfully run `git rebase placeholder`
    # Then there should be 6 commit entries in the git log
    # But there should be exactly 6 jpgs in "../.lolcommits/yuh8history"

