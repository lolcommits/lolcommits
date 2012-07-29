Feature: Plugins Work

  Scenario: Lolcommits.com integration works
    Given a git repository named "dot_com"
    And an empty file named "dot_com/FOOBAR"
    When I cd to "dot_com"
    And I successfully run `lolcommits --enable`
    And I run `lolcommits --config` and wait for output
    And I enter "dot_com" for "Plugin Name"
    And I enter "true" for "enabled"
    And I enter "b2a70ac0b64e012fa61522000a8c42dc" for "api_key"
    And I enter "b2a720b0b64e012fa61522000a8c42dc" for "api_secret"
    And I enter "c4aed530b64e012fa61522000a8c42dc" for "repo_id"
    Then I should be presented "Successfully Configured"
    When I successfully run `git add .`
    And I successfully run `git commit -m 'can haz commit'`
    Then the output should contain "*** Preserving this moment in history."
    And there should be 1 jpg in "../.lolcommits/dot_com"

  Scenario: Disable loltext
    Given a git repository named "loltext"
    And an empty file named "loltext/FOOBAR"
    When I cd to "loltext"
    And I successfully run `lolcommits --enable`
    And I run `lolcommits --config` and wait for output
    And I enter "loltext" for "Plugin Name"
    And I enter "false" for "enabled"
    Then I should be presented "Successfully Configured"
    When I successfully run `git add .`
    And I successfully run `git commit -m 'can haz commit'`
    Then the output should contain "*** Preserving this moment in history."
    And there should be 1 jpg in "../.lolcommits/loltext"

