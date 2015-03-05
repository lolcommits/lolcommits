Feature: Plugins Work

  Background:
    Given a mocked home directory

  @slow_process @unstable
  Scenario: Lolcommits.com integration works
    Given I am in a git repo named "dot_com" with lolcommits enabled
    When I run `lolcommits --config` interactively
      And I wait for output to contain "Name of plugin to configure:"
      Then I type "dot_com"
      And I wait for output to contain "enabled:"
      Then I type "true"
      And I wait for output to contain "api_key:"
      Then I type "b2a70ac0b64e012fa61522000a8c42dc"
      And I wait for output to contain "api_secret:"
      Then I type "b2a70ac0b64e012fa61522000a8c42dc"
      And I wait for output to contain "repo_id:"
      Then I type "b2a70ac0b64e012fa61522000a8c42dc"
    Then the output should contain "Successfully configured plugin: dot_com"
