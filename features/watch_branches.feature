@javascript
Feature: As a user
  I want to watch/unwatch branches

Background:
  Given I have the repository 'repo1'
  And the repository 'repo1' has the following branches
  | Name    | Watched |
  | master  | true    |
  | develop | false   |

Scenario Outline: Watch/Unwatch a branch
  Given I am on the repositories page
  When I click on 'repo1'
  And I <Action> the branch '<Branch>'
  Then I should see all the following
  | Content                             |
  | Successfully <New Status> <Branch>  |
  And the branch '<Branch>' should be <New Status>

  Examples:
  | Branch  | Action  | New Status |
  | master  | unwatch | unwatched  | 
  | develop | watch   | watched    |
