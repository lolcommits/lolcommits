Feature: Plugins Work

  @slow_process @unstable
  Scenario: Lolcommits.com integration works
    Given I am in a git repository named "dot_com" with lolcommits enabled
    When I run `lolcommits --config` and wait for output
    And I enter "dot_com" for "Plugin Name"
    And I enter "true" for "enabled"
    And I enter "b2a70ac0b64e012fa61522000a8c42dc" for "api_key"
    And I enter "b2a720b0b64e012fa61522000a8c42dc" for "api_secret"
    And I enter "c4aed530b64e012fa61522000a8c42dc" for "repo_id"
    Then I should be presented "Successfully configured plugin: dot_com"
    When I do a git commit
    Then the output should contain "*** Preserving this moment in history."
    And there should be exactly 1 jpg in "../.lolcommits/dot_com"

  Scenario: Disable loltext
    Given I am in a git repository named "loltext" with lolcommits enabled
    And I run `lolcommits --config` and wait for output
    And I enter "loltext" for "Plugin Name"
    And I enter "false" for "enabled"
    Then I should be presented "Successfully configured plugin: loltext"
    When I do a git commit
    Then the output should contain "*** Preserving this moment in history."
    And there should be exactly 1 jpg in "../.lolcommits/loltext"

  Scenario: lolsrv integration works
    Given I am in a git repository named "lolsrv" with lolcommits enabled
    When I run `lolcommits --config` and wait for output
    And I enter "lolsrv" for "Plugin Name"
    And I enter "true" for "enabled"
    And I enter "http://localhost" for "server"
    Then I should be presented "Successfully configured plugin: lolsrv"
    When I do a git commit
    Then the output should contain "*** Preserving this moment in history."
    And there should be exactly 1 jpg in "../.lolcommits/lolsrv"

