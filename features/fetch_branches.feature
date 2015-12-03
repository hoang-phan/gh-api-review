Feature: As a user
  I want to fetch all branches of a repository

Scenario Outline:
  Given I have the repository '<Repository>'
  And there are some branches of repository on remote server
  And I am on the repositories page
  When I click on '<Repository>'
  And I click on 'Fetch branches from Github'
  Then I should see 'Request sent. Please reload page later'
  When I wait for the fetch branches worker
  Then the local branches of repository '<Repository>' should be reloaded

  Examples:
  | Repository |
  | Org/Repo1  |
