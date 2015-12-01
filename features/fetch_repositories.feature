Feature: As a user
  I want to fetch all repositories from github

Scenario:
  Given I am on the repositories page
  When I click on 'Fetch repositories from Github'
  Then I should see 'Request sent. Reload page when done'
  And the local repositories should be reloaded