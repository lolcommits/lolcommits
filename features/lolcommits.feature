Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "lolcommits"
    Then the exit status should be 0
    And the banner should be present

  Scenario: Enable in a naked git repository
    Given a git repository named "loltest"
    And the git repository named "loltest" has no "post-commit" hook
    
    When I cd to "loltest"
    And I successfully run `lolcommits --enable`
    
    Then the output should contain "installed lolcommmit hook as:"
    And the output should contain "(to remove later, you can use: lolcommits --disable)"
    And a file named ".git/hooks/post-commit" should exist
    And the exit status should be 0

  Scenario: Disable in a enabled git repository
    Given a git repository named "lolenabled"
    And the git repository named "lolenabled" has a "post-commit" hook

    When I cd to "lolenabled"
    And I successfully run `lolcommits --disable`

    Then the output should contain "removed"
    Then a file named ".git/hooks/post-commit" should not exist
    And the exit status should be 0
    