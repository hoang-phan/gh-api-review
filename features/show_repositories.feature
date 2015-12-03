Feature: As a user
  I want to see all repositories

Scenario: Show all repositories
  Given I have the following repositories
  | Name      |
  | Org/Repo1 |
  | Org/Repo2 |
  And I am on the repositories page
  Then I should see all the following
  | Content   |
  | Org/Repo1 |
  | Org/Repo2 |
