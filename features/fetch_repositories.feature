Feature: As a user
  I want to fetch all repositories from github

Scenario:
  Given I am on the root page
  And there are some repositories on remote server
  When I click on 'Fetch repositories from Github'
  Then I should see 'Request sent. Please reload page later'
  When I wait for the fetch repositories worker
  Then the local repositories should be reloaded
