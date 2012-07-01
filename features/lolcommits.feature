Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "lolcommits"
    Then the exit status should be 0
    And the banner should be present

  Scenario: Enable in a naked git repository
    Given a git repository located at "/tmp/loltest"
    When I run `lolcommits --enable`
    Then the output should contain:
      """
      installed lolcommmit hook as:
        -> /tmp/loltest/.git/hooks/post-commit
      (to remove later, you can use: lolcommits --disable)
      """
    And the following files should exist: 
      | /tmp/loltest/.git/hooks/post-commit |
    And the exit status should be 0

