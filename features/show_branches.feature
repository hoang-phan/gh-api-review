Feature: As a user
  I want to see all branches from a specific repository

Scenario Outline:
  Given I have the repository '<Repository>'
  And I am on the repositories page
  And the repository '<Repository>' has the following branches
  | Name    |
  | master  |
  | develop |
  When I click on '<Repository>'
  Then I should see all the following
  | Content |
  | master  |
  | develop |

  Examples:
  | Repository |
  | Org/Repo1  |
