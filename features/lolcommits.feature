Feature: Basic UI functionality

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
    And a file named ".git/hooks/post-commit" should not exist
    And the exit status should be 0

  @simulate-env
  Scenario: Commiting in an enabled repo triggers capture
    Given a git repository named "testcapture"
    And an empty file named "testcapture/FOOBAR"
    When I cd to "testcapture"
    And I successfully run `lolcommits --enable`
    And I successfully run `git add .`
    And I successfully run `git commit -m 'can haz commit'`
    Then the output should contain "*** Preserving this moment in history."
    And a directory named "tmp/aruba/.lolcommits/testcapture" should exist
    And a file named "tmp/aruba/.lolcommits/testcapture/tmp_snapshot.jpg" should not exist
    And there should be 1 jpg in "tmp/aruba/.lolcommits/testcapture"

  @simulate-env
  Scenario: Configuring Plugin
    Given a git repository named "config-test"
    When I cd to "config-test"
    And I run `lolcommits --configure` and wait for output
    And I enter "loltext" for "Plugin Name"
    And I enter "true" for "enabled"
    Then I should be presented "Successfully Configured"
    And a file named "tmp/aruba/.lolcommits/config-test/config.yml" should exist
    When I successfully run `lolcommits --show-config`
    Then the output should contain "loltext:"
    And the output should contain "enabled: true"
    
  @simulate-env
  Scenario: Configuring Plugin In Test Mode
    Given a git repository named "testmode-config-test"
    When I cd to "testmode-config-test"
    And I run `lolcommits --configure --test` and wait for output
    And I enter "loltext" for "Plugin Name"
    And I enter "true" for "enabled"
    Then I should be presented "Successfully Configured"
    And a file named "tmp/aruba/.lolcommits/test/config.yml" should exist
    When I successfully run `lolcommits --test --show-config`
    Then the output should contain "loltext:"
    And the output should contain "enabled: true"


  @simulate-env
  Scenario: test capture should work regardless of whether in a git repository
    Given a directory named "nothingtoseehere"
    When I cd to "nothingtoseehere"
    And I run `lolcommits --test --capture`
    Then the output should contain "*** capturing in test mode"
    And the output should not contain "path does not exist (ArgumentError)"
    And the exit status should be 0 

  @simulate-env
  Scenario: test capture should store in its own test directory
    Given a git repository named "randomgitrepo"
    When I cd to "randomgitrepo"
    And I successfully run `lolcommits --test --capture`
    Then a directory named "tmp/aruba/.lolcommits/test" should exist
    And a directory named "tmp/aruba/.lolcommits/randomgitrepo" should not exist
