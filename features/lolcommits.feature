Feature: Basic UI functionality

  Background:
    Given a mocked home directory

  Scenario: App just runs
    When I get help for "lolcommits"
    Then the exit status should be 0
    And the banner should be present

  Scenario: Help should format nicely on a 80x24 terminal
    When I get help for "lolcommits"
    Then the output should not contain any lines longer than 80


