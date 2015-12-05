@javascript
Feature: As a user
  I want to watch/unwatch repositories

Scenario Outline: Watch/Unwatch a repository
  Given I have the <Old Status> repository '<Repository>'
  And I am on the repositories page
  When I <Action> the repository '<Repository>'
  Then I should see all the following
  | Content                                 |
  | Successfully <New Status> <Repository>  |
  And the repository '<Repository>' should be <New Status>

  Examples:
  | Old Status | Repository | Action  | New Status |
  | watched    | org2/repo2 | unwatch | unwatched  | 
  | unwatched  | org/repo   | watch   | watched    |
