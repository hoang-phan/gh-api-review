Feature: As a user
  I want to see all repositories

Scenario: Show all repositories
  Given I have the following repositories
  | Name      | Url               | Image Url             |
  | Org/Repo1 | https://mock1.com | https://mock.com/img1 |
  | Org/Repo2 | https://mock.com  | https://mock.com/img2 |
  And I am on the repositories page
  Then I should see all the following links
  | Link      | Url               |
  | Org/Repo1 | https://mock1.com |
  | Org/Repo2 | https://mock.com  |
